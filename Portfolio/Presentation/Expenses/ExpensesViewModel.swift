//
//  ExpensesViewModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 7/01/25.
//

import SwiftUI
import UIKit
import Combine

class ExpensesViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    @Published var recentYear: Int = 0
    @Published var assetId: Int
    @Published var openExpense: Expense?
    @Published var isShowingNewAssetMenu: Bool = false
    @Published var buttonPosition: CGPoint = .zero
    @Published var menuItems: [CustomMenuItem] = []
    private let fetchReportUseCase: FetchExpenseReportUseCaseProtocol
    private let yearCache = YearLRUCache()
    private var cancellables = Set<AnyCancellable>()

    var currency: String = {
        CurrentSessionHelper.shared.user?.currency.rawValue  ?? CurrencyModel.usd.rawValue
    }()

    init(
        assetId: Int,
        fetchReportUseCase: FetchExpenseReportUseCaseProtocol = FetchExpenseReportUseCase(repository: AttachmentRepository())
    ) {
        self.assetId = assetId
        let currentYear: Int = Calendar.current.component(.year, from: Date())
        self.fetchReportUseCase = fetchReportUseCase
        loadNextYear(from: currentYear)
        updateRecentYear(recent: currentYear)
    }

    func updateRecentYear(recent: Int) {
        guard recent != recentYear else {
            return
        }

        recentYear = recent
    }

    func openExpense(_ expense: Expense) {
        openExpense = expense
    }

    func loadTenPreviousYears() {
        // For example, if the user’s recentYear is 2025, we load 2024...2015
        let startYear = recentYear - 1  // The year just before current
        let endYear = recentYear - 10   // 10 years prior

        // Create an array of years in descending order (e.g., 2024 down to 2015).
        let range = Array(endYear...startYear)

        loadMultipleYears(range, isPrevious: true)
    }

    func loadPreviousYear(expense: Expense) {
        // Get the next year from the given expense's year
        let previous = expense.year - 1

        // Generate expenses for each month of the next year
        loadNextYear(from: previous, isPrevious: true)
    }

    func expensesFromYear(nextYear: Int) -> [Expense] {
        let nextYearExpenses = (1...12).map { month -> Expense in
            var components = DateComponents()
            components.year = nextYear
            components.month = month
            components.day = 1

            // Create a date for the 1st day of the given month in the next year
            let calendar = Calendar.current
            let date = calendar.date(from: components) ?? Date()

            return Expense(
                year: nextYear,
                month: month,
                price: 0, // Default price, can be adjusted
                date: date
            )
        }

        return nextYearExpenses
    }

    func loadNextYear(expense: Expense) {
        let nextYear = expense.year + 1
        loadMultipleYears([nextYear], isPrevious: false)
    }

    func loadNextYear(from year: Int, isPrevious: Bool = false) {
        loadMultipleYears([year], isPrevious: isPrevious)
    }

    func appendNewYears(newExpenses: [Expense], isPrevious: Bool = false) {
        var nextYearExpenses = newExpenses
        if isPrevious {
            let nextExpenses = expenses
            nextYearExpenses.append(contentsOf: nextExpenses)
            expenses = nextYearExpenses.sorted(by: { left, right in
                return left.year < right.year
            })
        } else {
            // Add the generated expenses to the array
            var newExpenses = expenses
            newExpenses.append(contentsOf: nextYearExpenses)
            expenses = newExpenses.sorted(by: { left, right in
                return left.year < right.year
            })
        }
    }

    private func fallbackZeroData(for years: [Int], isPrevious: Bool) {
        // 1) Create an array of zero-based Expense for each year & month.
        var fallbackExpenses: [Expense] = []

        for year in years {
            for month in 1...12 {
                let date = DateComponents(calendar: .current, year: year, month: month, day: 1).date ?? Date()
                let expense = Expense(year: year,
                                      month: month,
                                      price: 0,
                                      date: date)
                fallbackExpenses.append(expense)
            }
        }

        // 2) Group them by year and store in LRU cache
        let groupByYear = Dictionary(grouping: fallbackExpenses, by: { $0.year })
        for (year, exps) in groupByYear {
            yearCache.set(year: year, expenses: exps)
        }

        // 3) Merge from cache
        mergeCached(years, isPrevious: isPrevious)
    }

    func loadMultipleYears(_ yearsRange: [Int], isPrevious: Bool = false) {
        // 1) Check cache
        let missing = yearsRange.filter { yearCache.get(year: $0) == nil }
        guard !missing.isEmpty else {
            // All cached
            mergeCached(yearsRange, isPrevious: isPrevious)
            return
        }

        // 2) Fetch from server
        fetchReportUseCase.execute(assetId: assetId, years: missing)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print("Failed: \(err)")
                    // Create zero data for missing years
                    self.fallbackZeroData(for: missing, isPrevious: isPrevious)

                case .finished:
                    break
                }
            } receiveValue: { [weak self] newExpenses in
                guard let self = self else { return }

                // Separate by year
                let groupByYear = Dictionary(grouping: newExpenses, by: { $0.year })
                // Cache each year
                for (year, exps) in groupByYear {
                    self.yearCache.set(year: year, expenses: exps)
                }
                // Merge from cache
                self.mergeCached(yearsRange, isPrevious: isPrevious)
            }
            .store(in: &cancellables)
    }

    /// merges from the cache & sorts
    private func mergeCached(_ yearsRange: [Int], isPrevious: Bool) {
        var newExpenses = expenses
        for y in yearsRange {
            if let exps = yearCache.get(year: y) {
                newExpenses.append(contentsOf: exps)
            }
        }
        // sort by year, month
        newExpenses.sort { lhs, rhs in
            if lhs.year != rhs.year {
                return lhs.year < rhs.year
            } else {
                return lhs.month < rhs.month
            }
        }
        expenses = newExpenses

        // update recentYear if needed
        if isPrevious, let minYear = yearsRange.min() {
            updateRecentYear(recent: minYear)
        } else if let maxYear = yearsRange.max() {
            updateRecentYear(recent: maxYear)
        }
    }

    func resetToYearFrom(year: Int) {
        // Clear the entire cache so we start fresh
        yearCache.clear()

        // Also clear any old data from `expenses`
        expenses.removeAll()

        // Now fetch from the server for exactly that year
        loadMultipleYears([year], isPrevious: false)
    }

    private func addMoreYearsToMenu(increase: Bool = true) {
        let yearsFromItems = menuItems.compactMap { Int($0.title ?? "") }.sorted()
        let yearTitle = increase ? yearsFromItems.last : yearsFromItems.first
        let lastYear = yearTitle ?? recentYear
        var nextYearsInt = (1...10).map { lastYear + (increase ? $0 : -$0) }
        if !increase {
            nextYearsInt.reverse()
        }
        var nextYears = nextYearsInt.map(menuItemFromYear)
        var legacyYears = yearsFromItems.map(menuItemFromYear)
        if increase {
            legacyYears.append(contentsOf: nextYears)
            setItems(newMenuItems: legacyYears)
        } else {
            nextYears.append(contentsOf: legacyYears)
            setItems(newMenuItems: nextYears)
        }
    }

    private func menuItemFromYear(_ year: Int) -> CustomMenuItem {
        return CustomMenuItem(
            title: "\(year)",
            textColor: .blackPortfolio,
            action: { [weak self] in
                self?.resetToYearFrom(year: year)
                self?.isShowingNewAssetMenu = false
            }
        )
    }

    private func setItems(newMenuItems: [CustomMenuItem]) {
        let upButton = CustomMenuItem(
            image: "upToMoreIcon",
            textColor: .blackPortfolio,
            action: { [weak self] in
                self?.addMoreYearsToMenu(increase: false)
            }
        )

        let downButton = CustomMenuItem(
            image: "downToMoreIcon",
            textColor: .blackPortfolio,
            action: { [weak self] in
                self?.addMoreYearsToMenu()
            }
        )
        var result = [upButton]
        result.append(contentsOf: newMenuItems)
        result.append(downButton)
        menuItems = result
    }

    func loadMenuItemsFromExpenses() {
        var years = Set(expenses.map(\.year))
        if years.count < 10 {
            let first = years.first ?? recentYear
            years = Set((0...10).map({ first + $0 }))
        }

        let newMenuItems = years.sorted().map(menuItemFromYear)
        setItems(newMenuItems: newMenuItems)
    }

    func sortAllItems(ascendent: Bool) {
        expenses = expenses.sorted { left, right in
            if ascendent {
                return left.year < right.year
            } else {
                return right.year < left.year
            }
        }
    }

}

struct Expense: Identifiable, Equatable {
    var id = UUID()
    var year: Int
    var month: Int
    var price: Double
    var date: Date

    var monthName: String {
        return Date.monthName(from: month)
    }
}
