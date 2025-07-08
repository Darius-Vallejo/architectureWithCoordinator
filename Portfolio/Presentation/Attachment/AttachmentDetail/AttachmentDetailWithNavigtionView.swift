//
//  AttachmentDetailWithNavigtionView.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 31/01/25.
//

import SwiftUI

struct AttachmentDetailWithNavigtionView: View {
    @StateObject var viewModel: AttachmentDetailViewModel
    @StateObject var navigationAdapter: AttachmentDetailNavigationAdapter = .init()

    var body: some View {
        NavigationStack(path: $navigationAdapter.path) {
            AttachmentDetailView(viewModel: viewModel)
                .navigationDestination(for: AttachmentDetailViewModel.Navigation.self, destination: view(for:))
        }
        .environmentObject(navigationAdapter)
        .onAppear {
            viewModel.onOpenDetail = {
                navigationAdapter.pushTo(.editAttachment)
            }
        }
    }
}
