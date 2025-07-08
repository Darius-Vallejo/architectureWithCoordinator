//
//  AttachmentDetailWithNavigationCoordinator.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 1/02/25.
//

import SwiftUI

extension AttachmentDetailWithNavigtionView {
    @ViewBuilder
    func view(for destination: AttachmentDetailViewModel.Navigation) -> some View {
        switch destination {
        case .editAttachment:
            UpdateAttachmentView(viewModel: .init(attachment: viewModel.attachment,
                                                  onSave: { attachment in
                viewModel.attachment = attachment
                navigationAdapter.popBack()
            }))
        }
    }
}
