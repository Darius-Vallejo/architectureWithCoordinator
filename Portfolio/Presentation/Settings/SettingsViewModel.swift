//
//  SettingsViewModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 24/11/24.
//

import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var shouldShowError: Bool = false
    @Published var isLoading: Bool = false
    @Published var isPrivate: Bool = true
    @Published var isOpenPictureSheet: Bool = false
    @Published var isOpenCurrencySheet: Bool = false
    @Binding var userProfile: UserProfileModel?
    let updateUserPrivacityUseCase: UpdateUserPrivacityUseCaseProtocol
    let removeSessionUseCase: RemoveSessionUseCaseProtocol

    init(retriveSessionUseCase: RemoveSessionUseCaseProtocol = RemoveSessionUseCase(SessionRepository.shared),
         userProfile: Binding<UserProfileModel?>,
         updateUserPrivacityUseCase: UpdateUserPrivacityUseCaseProtocol = UpdateUserPrivacityUseCase(repository: UserProfileRepository())) {
        self.updateUserPrivacityUseCase = updateUserPrivacityUseCase
        self._userProfile = userProfile
        self.isPrivate = userProfile.wrappedValue?.privateAccount ?? true
        self.removeSessionUseCase = retriveSessionUseCase
    }

    func changePrivacity(isPrivate: Bool) {
        let previousState = self.isPrivate
        self.isPrivate = isPrivate
        Task {
            do {
                let userInfo = try await updateUserPrivacityUseCase.execute(privacity: isPrivate)
                await MainActor.run {
                    self.userProfile = userInfo
                    self.shouldShowError = false
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to change the currency, there is an issue with this action. Please try again."
                    self.shouldShowError = true
                    isLoading = false
                    self.isPrivate = previousState
                }
            }
        }
    }

    func logout() {
        do {
            try removeSessionUseCase.execute()
        } catch {
            print("Error", error)
        }
    }

}
