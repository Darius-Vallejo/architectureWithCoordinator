//
//  ExpensesView.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 6/01/25.
//

import SwiftUI

struct ExpensesView: View {

    @EnvironmentObject var navigatioAdapter: NavigationAdapterForAssetDetail
    @ObservedObject var viewModel: ExpensesViewModel

    var body: some View {
        VStack {
            HStack {
                Text(String(viewModel.recentYear))
                    .font(.newBlackTypefaceSemibold28)
                    .foregroundStyle(Color.blackPortfolio)
                    .padding(.bottom, 8)
                    .padding(.top, 20)
                Spacer()
            }
            HStack {
                Text(String.localized(.month))
                    .foregroundStyle(Color.neutralGray300)
                    .font(.interDisplayMedium14)
                    .frame(width: 100, alignment: .leading)
                Text(String.localized(.expenses))
                    .foregroundStyle(Color.neutralGray300)
                    .font(.interDisplayMedium14)
                Spacer()
                HStack(alignment: .center) {

                    //sortButton
                    filtersButton
                }
            }
            .frame(maxWidth: .infinity)
            Divider()
            Spacer()
            grillView
        }
        .padding(.horizontal, 16)
        .addBackButton(andPrincipalTitle: String.localized(.expenseHistory), isTransparent: true)
        .fullScreenCover(item: $viewModel.openExpense) { expense in
            ExpenseDetailView(viewModel: .init(expense: expense, assetId: viewModel.assetId)) {
                viewModel.resetToYearFrom(year: expense.year)
                viewModel.openExpense = nil
            }
        }
        .if(viewModel.isShowingNewAssetMenu, transform: { ztack in
            ztack.overlay(
                    CustomMenuView(
                           isShown: $viewModel.isShowingNewAssetMenu,
                           position: viewModel.buttonPosition,
                           items: viewModel.menuItems,
                           backgroundOpacity: 0.1,
                           menuWidth: 145,
                           cornerRadius: 12,
                           shadowRadius: 1,
                           shouldCloseOnTap: false,
                           maxHeight: 300
                       )
                )
        })
    }

    private var sortButton: some View {
        GeometryReader { geometry in
            Image("yearsFilterIcon")
                .background(
                    Color.lightGreyPortfolio
                        .frame(width: 40, height: 32)
                        .roundedRectangle(cornerRadius: 32)
                )
                .frame(width: 40, height: 20)
                .onTapGesture {
                    withAnimation(.linear) {
                        viewModel.isShowingNewAssetMenu.toggle()
                    }
                    viewModel.buttonPosition = .init(x: geometry.frame(in: .global).minX - 10,
                                                     y: geometry.frame(in: .global).maxY - 20)

                }
        }
        .frame(width: 40, height: 20)
    }

    var filtersButton: some View {
        GeometryReader { geometry in
            HStack(spacing: 8) {
                Image("filtersIcon")
                Text(String.localized(.filter))
                    .foregroundStyle(Color.blackPortfolio)
                    .font(.interDisplayMedium14)
            }
            .frame(width: 85, height: 34)
            .background(
                Color.yellowPortfolio
                    .roundedRectangle(cornerRadius: 34)
            )
            .onTapGesture {
                withAnimation(.linear) {
                    viewModel.isShowingNewAssetMenu.toggle()
                }
                viewModel.buttonPosition = .init(x: geometry.frame(in: .global).minX,
                                                 y: geometry.frame(in: .global).maxY + 150)

                viewModel.loadMenuItemsFromExpenses()
            }
        }
        .frame(width: 85, height: 34)
    }

    var grillView: some View {
        ExpensesGrillView(viewModel: viewModel) { expense in
            viewModel.openExpense = expense
        }
    }
}

#Preview {
    ExpensesView(viewModel: .init(assetId: 0))
}
