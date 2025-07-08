//
//  UpdateUserNicknameUseCase.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 3/12/24.
//


import Combine
import Alamofire

class UpdateUserNicknameUseCase: UpdateUserNicknameUseCaseProtocol {
    let repository: UserProfileRepositoryProtocol

    init(repository: UserProfileRepositoryProtocol) {
        self.repository = repository
    }

    func execute(nickname: String) async throws -> UserProfileModel {
        return try await repository.updateUserNickname(nickname: nickname).async()
    }
}
