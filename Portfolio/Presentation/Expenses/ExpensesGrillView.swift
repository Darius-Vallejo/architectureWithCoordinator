//
//  ExpensesView 2.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 7/01/25.
//

import SwiftUI

struct ExpensesGrillView: View {
    @State private var lastScrollOffset: CGFloat = 0
    @State private var isScrollingDown: Bool = false
    @ObservedObject var viewModel: ExpensesViewModel
    var onTapGesture: ((_ expense: Expense)->Void)?

    var body: some View {
        ScrollOffsetView(content: {
            LazyVStack {
                ForEach(viewModel.expenses) { expense in
                    ExpenseRow(expense: expense, currency: viewModel.currency)
                        .onTapGesture {
                            onTapGesture?(expense)
                        }
                        .onDisappear {
                            if !isScrollingDown {
                                viewModel.updateRecentYear(recent: expense.year)
                            }
                        }
                        .onAppear {
                            if isScrollingDown {
                                viewModel.updateRecentYear(recent: expense.year)
                            }
                            if expense == viewModel.expenses.last {
                                viewModel.loadNextYear(expense: expense)
                            }
                        }
                }
            }
        }, onScroll: { currentOffset in
            isScrollingDown = currentOffset > lastScrollOffset
            lastScrollOffset = currentOffset
        }) {
            viewModel.loadTenPreviousYears()
        }
    }
}
