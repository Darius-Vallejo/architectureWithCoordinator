//
//  TakePhotoSettingsViewModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 12/12/24.
//
import SwiftUI
import Combine

class TakePhotoSettingsViewModel: ObservableObject {

    private var uploadUserProfileImageUseCase: UploadUserProfileImageUseCaseProtocol
    @Published var bannerAction: BannerActionModel = .init()
    @Binding var userInfo: UserProfileModel?
    @Published var isLoading: Bool = false
    var photoHasChanged = PassthroughSubject<Void, Never>()

    init(
        userInfo: Binding<UserProfileModel?>,
        uploadUserProfileImageUseCase: UploadUserProfileImageUseCaseProtocol = UploadUserProfileImageUseCase(repository: UserProfileRepository())
    ) {
        self._userInfo = userInfo
        self.uploadUserProfileImageUseCase = uploadUserProfileImageUseCase
    }


    func uploadProfileImage(selectedImage: UIImage?) {
        guard let selectedImage = selectedImage else {
            print("No image selected for upload.")
            showError()
            return
        }
        isLoading = true
        Task {
            do {
                let userInfo = try await uploadUserProfileImageUseCase.execute(image: selectedImage)
                await MainActor.run {
                    self.userInfo?.profilePicture = ""
                    showSuccess()
                    isLoading = false
                    self.userInfo?.profilePicture = userInfo.profilePicture
                    photoHasChanged.send()
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
