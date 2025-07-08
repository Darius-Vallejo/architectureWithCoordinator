//
//  CreateNewAsset.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 28/11/24.
//

import SwiftUI

struct CreateNewAssetView: View {

    @ObservedObject var viewModel: CreateNewAssetViewModel
    @ObservedObject var navigationAdapter: NavigationAdapterForAsset
    @StateObject var uploadImagesViewModel: UploadImagesViewModel = .init()
    @Environment(\.dismiss) var dismiss
    private let gridColumns = CreateNewAssetViewConstants.Dimensions.gridColumns
    @EnvironmentObject var modalAdapter: UserProfileViewModalAdapter

    init(viewModel: CreateNewAssetViewModel, navigationAdapter: NavigationAdapterForAsset) {
        self.viewModel = viewModel
        self.navigationAdapter = navigationAdapter
    }

    var body: some View {
        NavigationStack(path: $navigationAdapter.path) {
            VStack(alignment: .leading, spacing: CreateNewAssetViewConstants.Dimensions.vStackSpacing) {
                headerView
                Spacer()
            }
            .padding(.top, CreateNewAssetViewConstants.Dimensions.topPadding)
            .padding(.horizontal, CreateNewAssetViewConstants.Dimensions.horizontalPadding)
            .addBackButton(andPrincipalTitle: viewModel.title)
            .navigationDestination(
                for: CreateNewAssetViewModel.Navigation.self,
                destination: { item in
                    navigationCoordinator(
                        for: item,
                        didCreateAssetSuccessfully: { [weak navigationAdapter, weak viewModel] _ in
                            dismiss.callAsFunction()
                            
                            if let viewModel {
                                navigationAdapter?.didCreateAssetSuccessfully?(viewModel.assetType)
                            }
                        }
                    )
            })
            .addDoneButtonToNavigation(title: String.localized(.close), actionBeforeDismiss: {
                let adapter = ModalAdapter<NewAssetModel>()
                adapter.presentModal = nil
                modalAdapter.newAseetModalObject = adapter
            })
        }
        .environmentObject(navigationAdapter)
    }

    var headerView: some View {
        Group {
            Text(String.localized(.onboardingNewAssetTitle))
                .font(CreateNewAssetViewConstants.Fonts.headerTitleFont)
                .foregroundStyle(CreateNewAssetViewConstants.Colors.headerTitleColor)
            Text(String.localized(.onboardingNewAssetDescription))
                .font(CreateNewAssetViewConstants.Fonts.headerDescriptionFont)

            NavigationLink(value: CreateNewAssetViewModel.Navigation.uploadImages) {
                SettingRow(iconName: CreateNewAssetViewConstants.Assets.libraryIcon,
                           iconColor: CreateNewAssetViewConstants.Colors.iconColor,
                           title: String.localized(.chooseFromLibrary))
            }
            .padding(.top, CreateNewAssetViewConstants.Dimensions.navigationLinkTopPadding)
            Divider()
            NavigationLink(value: CreateNewAssetViewModel.Navigation.takeImage) {
                SettingRow(iconName: CreateNewAssetViewConstants.Assets.cameraIcon,
                           iconColor: CreateNewAssetViewConstants.Colors.iconColor,
                           title: String.localized(.takePhoto))
            }
            Divider()
        }
    }
}

#Preview {
    CreateNewAssetView(viewModel: .init(assetType: .house), navigationAdapter: .init())
}
