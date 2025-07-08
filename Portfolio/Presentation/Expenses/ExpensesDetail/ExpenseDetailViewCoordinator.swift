//
//  ExpenseDetailViewCoordinator.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 25/01/25.
//

import SwiftUI

extension ExpenseDetailView {

    @ViewBuilder
    func view(for destination: ExpenseDetailViewModel.Navigation) -> some View {
        switch destination {
        case .createNewExpense: CreateNewExpense(viewModel: viewModel.newExpesesViewModel)
                .onAppear {
                    viewModel.newExpesesViewModel.onSave = {
                        navigationAdapter.popBack()
                        viewModel.loadAttachments()
                        viewModel.newExpesesViewModel.resetData()
                    }
                }
        case .attachmentSelect: AttachmentListForExpenseDetailView(viewModel: .init(assetId: viewModel.assetId,
                                                                                    isFromExpenses: true)) { result in
            navigationAdapter.popBack()
            viewModel.setupExpenseWithResult(result)
        }
        case .detailOfAttachment:
            AttachmentDetailView(viewModel: viewModel.attachmentDetailViewModel)
                .onAppear {
                    viewModel.attachmentDetailViewModel.onOpenDetail = {
                        navigationAdapter.pushTo(.updateAttachment)
                    }
                }
        case .updateAttachment:
            if let selected = viewModel.selectedAttachment {
                UpdateAttachmentView(viewModel: .init(attachment: selected,
                                                      onSave: { attachment in
                    navigationAdapter.popBack()
                    viewModel.loadAttachments()
                }))
            } else {
                EmptyView()
            }
        }
    }
}
