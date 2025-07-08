//
//  AssetDetailViewCoordinator.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 6/01/25.
//

import SwiftUI

extension AssetDetailView {

    @ViewBuilder
    func view(for destination: AssetDetailViewModel.Navigation) -> some View {
        switch destination {
        case .attachment: AttachmentView(viewModel: .init(assetId: viewModel.asset.id))
        case .expenses: ExpensesView(viewModel: .init(assetId: viewModel.asset.id))
        case .addNewAttachment: AddNewAttachmentView(viewModel: viewModel.addNewAttachmentViewModel)
                .onAppear {
                    viewModel.addNewAttachmentViewModel.onSave = {
                        navigatioAdapter.popBack()
                    }
        }
        }
    }
}
