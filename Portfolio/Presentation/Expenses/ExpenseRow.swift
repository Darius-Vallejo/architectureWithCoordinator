//
//  ExpenseRow.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 7/01/25.
//

import SwiftUI

struct ExpenseRow: View {
    var expense: Expense
    var currency: String

    var formattedPrice: String {
        return String.formatToCurrency(expense.price,
                                       currencyCode: currency) ?? .empty
    }

    var body: some View {
        VStack {
            HStack {
                Text(expense.monthName)
                    .font(.newBlackTypefaceSemibold16)
                    .foregroundStyle(Color.blackPortfolio)
                    .frame(width: 100, alignment: .leading)
                Text(formattedPrice)
                    .font(.newBlackTypefaceRegular16)
                    .foregroundStyle(Color.blackPortfolio)
                Spacer()
                Image("goDetailExpenseIcon")
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 4)
            Divider()
        }
    }
}
