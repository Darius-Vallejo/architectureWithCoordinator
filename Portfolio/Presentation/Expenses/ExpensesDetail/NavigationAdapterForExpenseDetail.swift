//
//  NavigationAdapterForExpenseDetail.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 25/01/25.
//


import SwiftUI

class NavigationAdapterForExpenseDetail: ObservableObject {
    @Published var path: NavigationPath = .init()

    func pushTo(_ action: ExpenseDetailViewModel.Navigation) {
        path.append(action)
    }

    func popBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    
}
