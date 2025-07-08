//
//  ChangeUserNameViewModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 3/12/24.
//

import SwiftUI
import Combine

class ChangeUserNameViewModel: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var nickname: String = ""
    @Published var shouldShowError: Bool = false
    @Published var isLoading: Bool = false
    @Binding var userInfo: UserProfileModel?
    var nickNameHasChanged = PassthroughSubject<Void, Never>()

    let updateUserNicknameUseCase: UpdateUserNicknameUseCaseProtocol

    init(userInfo: Binding<UserProfileModel?>,
         updateUserNicknameUseCase: UpdateUserNicknameUseCaseProtocol = UpdateUserNicknameUseCase(repository: UserProfileRepository())) {
        self.updateUserNicknameUseCase = updateUserNicknameUseCase
        self._userInfo = userInfo
        self.nickname = userInfo.wrappedValue?.nickname ?? .empty
    }

    func changeNickname() {
        isLoading = true
        Task {
            do {
                let userInfo = try await updateUserNicknameUseCase.execute(nickname: nickname)
                await MainActor.run {
                    self.userInfo = userInfo
                    self.shouldShowError = false
                    nickNameHasChanged.send()
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to change the nickname, there is an issue with this action. Please try again."
                    self.shouldShowError = true
                    isLoading = false
                }
            }
        }
    }
}
