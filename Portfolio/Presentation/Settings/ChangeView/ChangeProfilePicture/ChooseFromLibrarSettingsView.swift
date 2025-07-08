//
//  ChooseFromLibrarySettingsView.swift
//  Portfolio
//

import SwiftUI
import PhotosUI
import UIKit

struct ChooseFromLibrarySettingsView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var zoomScale: CGFloat = 1.0
    @State private var dragOffset: CGSize = .zero
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: ChooseFromLibrarySettingsViewModel
    private let gridColumns = Dimensions.gridColumns

    private typealias Dimensions = ChooseFromLibrarySettingsViewConstants.Dimensions
    private typealias Behavior = ChooseFromLibrarySettingsViewConstants.Behavior

    var body: some View {
        ZStack {
            VStack {
                GeometryReader { geometry in
                    ZStack {
                        if let selectedImage = viewModel.selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width * zoomScale,
                                       height: geometry.size.width * zoomScale)
                                .offset(dragOffset)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            dragOffset = value.translation
                                        }
                                )
                                .gesture(
                                    MagnificationGesture()
                                        .onChanged { value in
                                            zoomScale = value.magnitude
                                        }
                                )
                        }
                    }
                }
                .frame(width: Dimensions.imageFrameWidth,
                       height: Dimensions.imageFrameHeight)
                .clipped()
                Spacer()
            }

            scrollView

            VStack {
                Spacer()
                if viewModel.isLoading {
                    ProgressView()
                        .tint(Color.blackPortfolio)
                        .scaleEffect(Dimensions.progressScale)
                }
                Spacer()
            }
        }
        .addBackButton(andPrincipalTitle: String.localized(.selectImage))
        .addDoneButtonToNavigation {
            viewModel.uploadProfileImage()
        }
        .onReceive(viewModel.photoHasChanged) {
            dismiss()
        }
        .padding(.top, Dimensions.topPadding)
        .onAppear {
            requestPhotoLibraryPermission()
        }
        .banner(isShown: $viewModel.bannerAction.shouldShow,
                type: viewModel.bannerAction.type,
                message: viewModel.bannerAction.message)
    }

    private var scrollView: some View {
        VStack {
            Color.black.opacity(Dimensions.maskOpacity)
                .frame(maxWidth: .infinity)
                .frame(height: Dimensions.maskHeight)
                .mask(
                    ZStack {
                        Rectangle()
                            .fill(Color.black)

                        Circle()
                            .frame(maxWidth: .infinity)
                            .frame(height: Dimensions.circleMaskHeight)
                            .blendMode(.destinationOut)
                    }
                )
                .allowsHitTesting(Behavior.allowsHitTesting)

            ScrollView(.vertical, showsIndicators: true) {
                LazyVGrid(columns: gridColumns, spacing: Dimensions.gridSpacing) {
                    ForEach(viewModel.recentImages, id: \.id) { image in
                        Image(uiImage: image.thumbnail)
                            .resizable()
                            .scaledToFill()
                            .frame(width: Dimensions.thumbnailWidth,
                                   height: Dimensions.thumbnailHeight)
                            .clipShape(RoundedRectangle(cornerRadius: Dimensions.thumbnailCornerRadius))
                            .background(Color.greyPortfolio)
                            .onTapGesture {
                                viewModel.selectedImage = image.fullImage
                            }
                    }
                }
                .padding(.top, Dimensions.gridTopPadding)

                HStack {
                    imagePicker
                }
                .padding(.top, Dimensions.pickerTopPadding)
            }
            .background(Color.white)
        }
    }

    private var imagePicker: some View {
        PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
            PrimaryButton(title: String.localized(.viewMoreImages)) {}
            .allowsHitTesting(false)
            .padding()
        }
        .onChange(of: selectedItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    viewModel.selectedImage = uiImage
                }
            }
        }
    }

    private func requestPhotoLibraryPermission() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized, .limited:
                viewModel.fetchRecentImages()
                print("Access granted to photo library.")
            case .denied, .restricted:
                print("Access denied to photo library.")
            case .notDetermined:
                print("Permission not determined yet.")
            @unknown default:
                print("Unknown authorization status.")
            }
        }
    }
}

#Preview {
    @Previewable @State var user: UserProfileModel?
    NavigationStack {
        ChooseFromLibrarySettingsView(viewModel: .init(userInfo: $user))
    }
}
