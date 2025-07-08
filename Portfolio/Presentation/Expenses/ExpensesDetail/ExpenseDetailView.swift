//
//  ExpenseDetailView.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 7/01/25.
//

import SwiftUI

struct ExpenseDetailView: View {

    @StateObject var viewModel: ExpenseDetailViewModel
    @StateObject var navigationAdapter: NavigationAdapterForExpenseDetail = .init()
    var dismiss: ()-> Void

    var body: some View {
        NavigationStack(path: $navigationAdapter.path) {
            VStack {
                HStack {
                    Text("\(viewModel.expense.monthName) \(String(viewModel.expense.year))")
                        .font(.newBlackTypefaceSemibold28)
                        .foregroundStyle(Color.blackPortfolio)
                        .padding(.bottom, 8)
                        .padding(.top, 20)
                    Spacer()
                }

                HStack {
                    Text(String.localized(.title))
                        .foregroundStyle(Color.neutralGray300)
                        .font(.interDisplayMedium14)
                    Spacer()
                    Text(String.localized(.expenses))
                        .foregroundStyle(Color.neutralGray300)
                        .font(.interDisplayMedium14)
                    Spacer()
                    Text(String.localized(.file))
                        .foregroundStyle(Color.neutralGray300)
                        .font(.interDisplayMedium14)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 8)
                Divider()

                if viewModel.attachments.isEmpty {
                    Spacer()
                    emptyView
                    Spacer()
                } else {
                    listOfExpenses
                }

                PrimaryButton(title: "Add New Expense") {
                    navigationAdapter.path.append(ExpenseDetailViewModel.Navigation.createNewExpense)
                }
            }
            .padding(.horizontal, 16)
            .addBackButton(andPrincipalTitle: "Specific Expense", onDismiss: dismiss)
            .navigationDestination(for: ExpenseDetailViewModel.Navigation.self,
                                   destination: view(for:))
        }
        .environmentObject(navigationAdapter)
        .onAppear {
            viewModel.loadAttachments()
        }
        .if(viewModel.isShowingNewAssetMenu, transform: { ztack in
            ztack.overlay(
                    CustomMenuView(
                           isShown: $viewModel.isShowingNewAssetMenu,
                           position: viewModel.buttonPosition,
                           items: viewModel.customMenuItems,
                           backgroundOpacity: 0.1,
                           menuWidth: 135,
                           cornerRadius: 12,
                           shadowRadius: 1
                       )
                )
        })
    }

    var listOfExpenses: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(viewModel.attachments, id: \.id) { expense in
                    VStack {
                        HStack {
                            Text(expense.name)
                                .foregroundStyle(Color.blackPortfolio)
                                .font(.newBlackTypefaceSemibold16)
                            Spacer()
                            Text(expense.formattedPrice)
                                .foregroundStyle(Color.blackPortfolio)
                                .font(.newBlackTypefaceRegular16)
                            Spacer()
                            GeometryReader { geometry in
                                Button {
                                    viewModel.customMenuItems = [
                                        CustomMenuItem(
                                            title: "Edit",
                                            image: "editAttachmentIcon",
                                            textColor: .blackPortfolio,
                                            action: {
                                                viewModel.selectedAttachment = expense
                                                navigationAdapter.pushTo(.updateAttachment)
                                            }
                                        ),
                                        CustomMenuItem(
                                            title: "Delete",
                                            image: "deleteAttachmentIcon",
                                            textColor: .danger700,
                                            action: {
                                                viewModel.deleteExpense(attachment: expense)
                                            }
                                        )
                                    ]
                                    withAnimation(.linear) {
                                        viewModel.isShowingNewAssetMenu.toggle()
                                    }
                                    viewModel.buttonPosition = .init(x: geometry.frame(in: .global).minX - 40,
                                                                     y: geometry.frame(in: .global).maxY + 40)
                                } label: {
                                    Image("viewMoreButton")
                                }
                            }
                            .frame(width: 10, height: 10)
                            .padding(.horizontal, 8)
                        }
                        .padding(.horizontal, 8)

                        Divider()
                    }
                    .onTapGesture {
                        viewModel.attachmentDetailViewModel.attachment = expense
                        navigationAdapter.path.append(ExpenseDetailViewModel.Navigation.detailOfAttachment)
                        viewModel.attachmentDetailViewModel.dismiss = {
                            viewModel.loadAttachments()
                            navigationAdapter.popBack()
                        }
                    }
                }
            }
        }
        .padding(.top, 10)
    }

    var emptyView: some View {
        VStack {
            Image("attachmentEmptyState")
                .renderingMode(.template)
                .scaledToFit()
                .foregroundStyle(Color.neutralGray200)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(Color.neutralGray)
                        .frame(width: 112, height: 112)
                )
                .padding(32)

            Text(String.localized(.attachmentTitle))
                .font(Font.newBlackTypefaceSemiBold32)
            Text(String.localized(.attachmentDescription))
                .font(Font.newBlackTypefaceRegular16)
        }
        .padding(.horizontal, 20)
    }
}


#Preview {
    ExpenseDetailView(viewModel: .init(expense:
            .init(year: 2025,
                  month: 1,
                  price: 20000,
                  date: DateComponents(calendar: .current,
                                       year: 2025,
                                       month: 4,
                                       day: 20).date ?? .now),
                                       assetId: 0,
                                       attachments: [
                                        .init(id: 1,
                                              name: "Main",
                                              value: 900.00,
                                              date: nil,
                                              description: nil,
                                              type: .appraisal,
                                              isCreatedAsAttachment: false,
                                              attachmentURL: nil,
                                              attachmentId: 0)
                                       ]), dismiss: {

                                       })
}
