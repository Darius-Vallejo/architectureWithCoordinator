//
//  CreateNewAssetWithSelectedImagesView.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 6/12/24.
//

import SwiftUI

struct CreateNewAssetWithSelectedImagesView: View {

    @EnvironmentObject var navigationAdapter: NavigationAdapterForAsset
    @StateObject var viewModel: CreateNewAssetWithSelectedImagesViewModel
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var modalAdapter: UserProfileViewModalAdapter
    private let gridColumns = CreateNewAssetWithSelectedImagesConstants.Dimensions.gridColumns

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: CreateNewAssetWithSelectedImagesConstants.Dimensions.vStackSpacing) {
                headerView
                gridViews
            }
            .padding(.top, CreateNewAssetWithSelectedImagesConstants.Dimensions.topPadding)
            .padding(.horizontal, CreateNewAssetWithSelectedImagesConstants.Dimensions.horizontalPadding)

            VStack {
                Spacer()
                PrimaryButton(title: String.localized(.save)) {
                    navigationAdapter.path.append(CreateNewAssetViewModel.Navigation.form)
                }
            }
            .padding(.bottom, CreateNewAssetWithSelectedImagesConstants.Dimensions.bottomPadding)
        }
        .addDoneButtonToNavigation(title: String.localized(.close),
                                   actionBeforeDismiss: {
            let adapter = ModalAdapter<NewAssetModel>()
            adapter.presentModal = nil
            modalAdapter.newAseetModalObject = adapter
        })
        .addBackButton(andPrincipalTitle: viewModel.assetType.navigationTitle)
    }

    var headerView: some View {
        Group {
            Text(String.localized(.onboardingNewAssetTitle))
                .font(CreateNewAssetWithSelectedImagesConstants.Fonts.headerTitleFont)
                .foregroundStyle(CreateNewAssetWithSelectedImagesConstants.Colors.headerTitleColor)
            Text(String.localized(.onboardingNewAssetDescription))
                .font(CreateNewAssetWithSelectedImagesConstants.Fonts.headerDescriptionFont)

            Button {
                navigationAdapter.path.append(CreateNewAssetViewModel.Navigation.uploadImages)
            } label: {
                SettingRow(iconName: CreateNewAssetWithSelectedImagesConstants.Assets.libraryIcon,
                           iconColor: CreateNewAssetWithSelectedImagesConstants.Colors.iconColor,
                           title: String.localized(.chooseFromLibrary))
            }
            .padding(.top, CreateNewAssetWithSelectedImagesConstants.Dimensions.buttonTopPadding)
            Divider()
            Button {
                navigationAdapter.path.append(CreateNewAssetViewModel.Navigation.takeImage)
            } label: {
                SettingRow(iconName: CreateNewAssetWithSelectedImagesConstants.Assets.cameraIcon,
                           iconColor: CreateNewAssetWithSelectedImagesConstants.Colors.iconColor,
                           title: String.localized(.takePhoto))
            }
            Divider()
        }
    }

    var gridViews: some View {
        return ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: gridColumns, spacing: CreateNewAssetWithSelectedImagesConstants.Dimensions.gridSpacing) {
                ForEach(viewModel.recentImages, id: \.id) { image in
                    ZStack {
                        Image(uiImage: image.thumbnail)
                            .resizable()
                            .scaledToFill()
                            .frame(width: CreateNewAssetWithSelectedImagesConstants.Dimensions.imageWidth,
                                   height: CreateNewAssetWithSelectedImagesConstants.Dimensions.imageHeight)
                            .clipShape(RoundedRectangle(cornerRadius: CreateNewAssetWithSelectedImagesConstants.Dimensions.imageCornerRadius))
                    }
                }
            }
            .padding(.top, CreateNewAssetWithSelectedImagesConstants.Dimensions.gridTopPadding)
            .padding(.bottom, CreateNewAssetWithSelectedImagesConstants.Dimensions.gridBottomPadding)
        }
        .background(CreateNewAssetWithSelectedImagesConstants.Colors.gridBackground)
    }
}

#Preview {
    CreateNewAssetWithSelectedImagesView(viewModel: .init(recentImages: [], assetType: .car))
}
