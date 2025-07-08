//
//  TakePhotoForAssetView.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 1/12/24.
//


import SwiftUI

struct TakePhotoForAssetView: View {
    @EnvironmentObject var navigationAdapter: NavigationAdapterForAsset
    var viewModel: UploadImagesViewModel
    @EnvironmentObject var modalAdapter: UserProfileViewModalAdapter

    var body: some View {
        TakePhotoView { capturedPhoto in
            if let photo = capturedPhoto {
                viewModel.addImageToSelectedList(image: photo)
            }
            navigationAdapter.path.append(CreateNewAssetViewModel.Navigation.selectedImages)
        }
        .addBackButton(andPrincipalTitle: String.localized(.takePhoto), color: .white)
        .addDoneButtonToNavigation(title: "Close", actionBeforeDismiss: {
            let adapter = ModalAdapter<NewAssetModel>()
            adapter.presentModal = nil
            modalAdapter.newAseetModalObject = adapter
        })
        .background(Color.black)
    }
}

#Preview {
    @Previewable @State var user: UserProfileModel?
    NavigationStack {
        TakePhotoSettingsView(viewModel: .init(userInfo: $user))
    }
}
