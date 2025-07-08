//
//  AttachmentView.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 6/01/25.
//

import SwiftUI

struct AttachmentView: View {
    
    @EnvironmentObject var navigatioAdapter: NavigationAdapterForAssetDetail
    @StateObject var viewModel: AttachmentViewModel

    var body: some View {
        AttachmentViewContent(viewModel: viewModel) {
            navigatioAdapter.path.append(AssetDetailViewModel.Navigation.addNewAttachment)
        }
    }

}


#Preview {
    AttachmentView(viewModel: .init(assetId: 0,
                                    attachments: [
        .init(id: 1,
              name: "Lorem ipsum",
              value: 200,
              date: nil,
              description: nil,
              type: .improvement,
              isCreatedAsAttachment: true,
              attachmentURL: nil,
              attachmentId: 2),
        .init(id: 3,
              name: "Lorem ipsum",
              value: 200,
              date: nil,
              description: nil,
              type: .improvement,
              isCreatedAsAttachment: true,
              attachmentURL: nil,
              attachmentId: 3),
        .init(id: 2,
              name: "Lorem ipsum",
              value: 200,
              date: nil,
              description: nil,
              type: .maintenance,
              isCreatedAsAttachment: true,
              attachmentURL: nil,
              attachmentId: 3)
    ]))
}
