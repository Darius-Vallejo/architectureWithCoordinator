//
//  TakePhotoSettingsView.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 25/11/24.
//

import SwiftUI

struct TakePhotoSettingsView: View {
    @StateObject var viewModel: TakePhotoSettingsViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        TakePhotoView { capturedPhoto in
            viewModel.uploadProfileImage(selectedImage: capturedPhoto)
            dismiss()
        }
        .padding(.top, 16)
        .addBackButton(andPrincipalTitle: String.localized(.takeImages), color: .white)
        .background(Color.black)
        .banner(isShown: $viewModel.bannerAction.shouldShow,
                type: viewModel.bannerAction.type,
                message: viewModel.bannerAction.message)
    }
}

#Preview {
    @Previewable @State var user: UserProfileModel?
    NavigationStack {
        TakePhotoSettingsView(viewModel: .init(userInfo: $user))
    }
}
