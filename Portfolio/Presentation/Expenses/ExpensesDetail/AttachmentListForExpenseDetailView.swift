//
//  AttachmentListForExpenseDetailView.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 25/01/25.
//

import SwiftUI

struct AttachmentListForExpenseDetailView: View {

    @StateObject var viewModel: AttachmentViewModel
    @State var showAddAttachmentToConfirm: Bool = false
    var onSave: ((_ result: NewAttachmentForExpenseViewModel.SavingResult)->Void)?


    var body: some View {
        AttachmentViewContent(viewModel: viewModel) {
            showAddAttachmentToConfirm = true
        }
        .sheet(item: $viewModel.attachmentToConfirm) { attachment in
            NewAttachmentForExpenseView(viewModel: .init(attachment: attachment,
                                                         save: { result in
                viewModel.attachmentToConfirm = nil
                onSave?(result)
            }))
        }
        .sheet(isPresented: $showAddAttachmentToConfirm) {
            NewAttachmentForExpenseView(viewModel: .init(save: { result in
                showAddAttachmentToConfirm.toggle()
                onSave?(result)
            }))
        }
    }

}


#Preview {
    AttachmentListForExpenseDetailView(viewModel: .init(assetId: 0,
                                                        attachments: [
                                                            .init(id: 1,
                                                                  name: "Lorem ipsum",
                                                                  value: 200,
                                                                  date: nil,
                                                                  description: nil,
                                                                  type: .improvement,
                                                                  isCreatedAsAttachment: true,
                                                                  attachmentURL: nil,
                                                                  attachmentId: 9),
                                                            .init(id: 3,
                                                                  name: "Lorem ipsum",
                                                                  value: 200,
                                                                  date: nil,
                                                                  description: nil,
                                                                  type: .improvement,
                                                                  isCreatedAsAttachment: true,
                                                                  attachmentURL: nil,
                                                                  attachmentId: 2),
                                                            .init(id: 2,
                                                                  name: "Lorem ipsum",
                                                                  value: 200,
                                                                  date: nil,
                                                                  description: nil,
                                                                  type: .maintenance,
                                                                  isCreatedAsAttachment: true,
                                                                  attachmentURL: nil,
                                                                  attachmentId: 2),
                                                        ],
                                                        isFromExpenses: true))
}
