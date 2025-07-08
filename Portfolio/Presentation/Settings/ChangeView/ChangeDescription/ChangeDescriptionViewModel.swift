//
//  ChangeDescriptionViewModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 4/12/24.
//



import SwiftUI
import Combine

class ChangeDescriptionViewModel: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var description: String = ""
    @Published var shouldShowError: Bool = false
    @Published var isLoading: Bool = false
    @Binding var userInfo: UserProfileModel?
    var descriptionHasChanged = PassthroughSubject<Void, Never>()

    let updateUserDescriptionUseCase: UpdateUserDescriptionUseCaseProtocol

    init(
        userInfo: Binding<UserProfileModel?>,
         updateUserDescriptionUseCase: UpdateUserDescriptionUseCaseProtocol = UpdateUserDescriptionUseCase(repository: UserProfileRepository())
    ) {
        self.updateUserDescriptionUseCase = updateUserDescriptionUseCase
        self._userInfo = userInfo
        self.description = userInfo.wrappedValue?.description ?? .empty
    }

    func changeDescription() {
        isLoading = true
        Task {
            do {
                let userInfo = try await updateUserDescriptionUseCase.execute(description: description)
                await MainActor.run {
                    self.userInfo = userInfo
                    self.shouldShowError = false
                    descriptionHasChanged.send()
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to change the description, there is an issue with this action. Please try again."
                    self.shouldShowError = true
                    isLoading = false
                }
            }
        }
    }
}
