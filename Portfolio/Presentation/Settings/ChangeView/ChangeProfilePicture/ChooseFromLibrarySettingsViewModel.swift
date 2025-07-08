//
//  ChooseFromLibrarySettingsViewModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 28/11/24.
//
import SwiftUI
import PhotosUI
import Combine

class ChooseFromLibrarySettingsViewModel: ObservableObject {
    @Published var recentImages: [RecentImage] = []
    @Published var selectedImage: UIImage? = nil
    @Published var bannerAction: BannerActionModel = .init()
    @Binding var userInfo: UserProfileModel?
    @Published var isLoading: Bool = false
    var photoHasChanged = PassthroughSubject<Void, Never>()

    var fetchImageUseCase: FetchImagesFromLibraryUseCaseProtocol
    var uploadUserProfileImageUseCase: UploadUserProfileImageUseCaseProtocol

    init(
        userInfo: Binding<UserProfileModel?>,
        fetchImageUseCase: FetchImagesFromLibraryUseCaseProtocol = FetchImagesFromLibraryUseCase(repository: FetchImagesFromLibraryRepository(pageSize: 9)),
        uploadUserProfileImageUseCase: UploadUserProfileImageUseCaseProtocol = UploadUserProfileImageUseCase(repository: UserProfileRepository())
    ) {
        self._userInfo = userInfo
        self.fetchImageUseCase = fetchImageUseCase
        self.uploadUserProfileImageUseCase = uploadUserProfileImageUseCase
    }

    @MainActor
    func fetchRecentImages() {
        Task {
            do {
                let images = try await fetchImageUseCase.execute(page: 0, isGettingFullImage: true)
                recentImages = images
                selectedImage = images.count > 0 ? images[0].fullImage : nil
            } catch {
                print("Error")
            }
        }
    }

    func uploadProfileImage() {
        isLoading = true
        guard let selectedImage = selectedImage else {
            print("No image selected for upload.")
            showError()
            return
        }

        Task {
            do {
                let user = try await uploadUserProfileImageUseCase.execute(image: selectedImage)
                await MainActor.run {
                    self.userInfo? = user
                    showSuccess()
                    photoHasChanged.send()
                    isLoading = false
                }
                print("Profile image uploaded successfully.")
            } catch {
                print("Error uploading profile image: \(error)")
                await MainActor.run {
                    showError()
                    isLoading = false
                }
            }
        }
    }

    func requestPhotoLibraryPermission() {
        PHPhotoLibrary.requestAuthorization {[unowned self] status in
            switch status {
            case .authorized, .limited:
                Task { @MainActor in
                    self.fetchRecentImages()
                }
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

    private func showError() {
        bannerAction.message = "Error!"
        bannerAction.type = .error
        bannerAction.shouldShow = true
    }

    private func showSuccess() {
        bannerAction.message = "Successful!"
        bannerAction.type = .success
        bannerAction.shouldShow = true
    }
}
