//
//  UploadImagesView.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 29/11/24.
//

import SwiftUI
import PhotosUI

struct UploadImagesView: View {
    @ObservedObject var viewModel: UploadImagesViewModel

    private let gridColumns = UploadImagesViewConstants.Dimensions.gridColumns
    @EnvironmentObject private var navigationAdapter: NavigationAdapterForAsset
    @EnvironmentObject var modalAdapter: UserProfileViewModalAdapter

    var body: some View {
        ZStack {
            VStack(spacing: UploadImagesViewConstants.Dimensions.vStackSpacing) {
                VStack {
                    NavigationLink(value: CreateNewAssetViewModel.Navigation.takeImage) {
                        SettingRow(iconName: UploadImagesViewConstants.Assets.takeNewImagesIcon,
                                   iconColor: UploadImagesViewConstants.Colors.iconColor,
                                   title: String.localized(.takeNewImages))
                    }
                    .padding(.top, UploadImagesViewConstants.Dimensions.topPadding)
                    Divider()
                }
                HStack {
                    Spacer()
                    imagePicker
                    Button {
                        viewModel.resetSelectedImages()
                    } label: {
                        HStack(spacing: UploadImagesViewConstants.Dimensions.hStackSpacing) {
                            Image("resetImages")
                                .renderingMode(.template)
                                .foregroundStyle(Color.blackPortfolio)
                            Text(String.localized(.reset))
                                .font(UploadImagesViewConstants.Fonts.selectButtonFont)
                                .foregroundStyle(UploadImagesViewConstants.Colors.selectButtonForeground)
                        }
                        .frame(width: UploadImagesViewConstants.Dimensions.selectButtonWidth,
                               height: UploadImagesViewConstants.Dimensions.selectButtonHeight)
                        .background(UploadImagesViewConstants.Colors.selectButtonBackground)
                        .roundedRectangle(cornerRadius: UploadImagesViewConstants.Dimensions.selectButtonCornerRadius)
                    }
                }
                gridViews
            }

            VStack {
                Spacer()
                PrimaryButton(title: String.localized(.save)) {
                    navigationAdapter.path.append(CreateNewAssetViewModel.Navigation.selectedImages)
                }
            }
            .padding(.bottom, UploadImagesViewConstants.Dimensions.bottomPadding)
        }
        .addBackButton(andPrincipalTitle: String.localized(.uploadImages))
        .addDoneButtonToNavigation(title: "Close", actionBeforeDismiss: {
            let adapter = ModalAdapter<NewAssetModel>()
            adapter.presentModal = nil
            modalAdapter.newAseetModalObject = adapter
        })
        .padding(.horizontal, UploadImagesViewConstants.Dimensions.horizontalPadding)
        .onAppear {
            viewModel.loadPhotos()
        }
    }


    private var imagePicker: some View {
        PhotosPicker(selection: $viewModel.selectedItems, matching: .images, photoLibrary: .shared()) {
            HStack(spacing: UploadImagesViewConstants.Dimensions.hStackSpacing) {
                Image(UploadImagesViewConstants.Assets.selectImagesIcon)
                Text(String.localized(.library))
                    .font(UploadImagesViewConstants.Fonts.selectButtonFont)
                    .foregroundStyle(UploadImagesViewConstants.Colors.selectButtonForeground)
            }
            .frame(width: UploadImagesViewConstants.Dimensions.selectButtonWidth,
                   height: UploadImagesViewConstants.Dimensions.selectButtonHeight)
            .background(UploadImagesViewConstants.Colors.selectButtonBackground)
            .roundedRectangle(cornerRadius: UploadImagesViewConstants.Dimensions.selectButtonCornerRadius)
        }
        .onChange(of: viewModel.selectedItems) { _, newItems in
            Task {
                var items: [UIImage] = []
                for item in newItems {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        items.append(image)
                    }
                }
                viewModel.addImageToSelectedList(images: items)
            }
        }
    }


    var gridViews: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: gridColumns, spacing: UploadImagesViewConstants.Dimensions.gridSpacing) {
                ForEach(viewModel.recentImages, id: \.id) { image in
                    ZStack {
                        Button {
                            viewModel.selectImage(id: image.id)
                        } label: {
                            Image(uiImage: image.thumbnail)
                                .resizable()
                                .scaledToFill()
                                .frame(width: UploadImagesViewConstants.Dimensions.imageWidth,
                                       height: UploadImagesViewConstants.Dimensions.imageHeight)
                                .clipShape(RoundedRectangle(cornerRadius: UploadImagesViewConstants.Dimensions.imageCornerRadius))
                        }

                        HStack {
                            VStack {
                                Group {
                                    if viewModel.checkIfImageIsSelected(image: image) {
                                        Image(UploadImagesViewConstants.Assets.checkIcon)
                                    } else {
                                        Circle()
                                            .stroke(UploadImagesViewConstants.Colors.selectionStrokeColor, lineWidth: 2)
                                            .shadow(radius: UploadImagesViewConstants.Dimensions.selectionShadowRadius)
                                    }
                                }
                                .frame(width: UploadImagesViewConstants.Dimensions.selectionIndicatorSize,
                                       height: UploadImagesViewConstants.Dimensions.selectionIndicatorSize)
                                .padding(UploadImagesViewConstants.Dimensions.selectionIndicatorPadding)
                                Spacer()
                            }
                            Spacer()
                        }
                        .allowsHitTesting(false)
                    }
                    .onAppear {
                        if let lastImage = viewModel.recentImages.last, lastImage == image {
                            viewModel.loadNextPage()
                        }
                    }
                }
            }
            .padding(.top, UploadImagesViewConstants.Dimensions.gridTopPadding)
        }
        .background(UploadImagesViewConstants.Colors.gridBackground)
    }
}

#Preview {
    NavigationStack {
        UploadImagesView(viewModel: .init())
    }
}
