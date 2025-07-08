//
//  CreateNewAssetViewCoordinator.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 13/12/24.
//

import SwiftUI

extension CreateNewAssetView {
    @ViewBuilder
    func navigationCoordinator(
        for type: CreateNewAssetViewModel.Navigation,
        didCreateAssetSuccessfully:  DidCreateAssetSuccessfully?
    ) -> some View {
        switch type {
        case .uploadImages:
            UploadImagesView(viewModel: uploadImagesViewModel)
        case .takeImage:
            TakePhotoForAssetView(viewModel: uploadImagesViewModel)
        case .selectedImages:
            CreateNewAssetWithSelectedImagesView(
                viewModel: .init(
                    recentImages: uploadImagesViewModel.getSelectedImages(),
                    assetType: viewModel.assetType
                )
            )
        case .form:
            CreateNewAssetForTypeView(
                viewModel: .init(
                    assetType: viewModel.assetType,
                    recentImages: uploadImagesViewModel.getSelectedImages(),
                    didCreateAssetSuccessfully: didCreateAssetSuccessfully
                )
            )
        }
    }
}
