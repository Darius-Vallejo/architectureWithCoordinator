//
//  UpdateUserPrivacityUseCase.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 6/12/24.
//


class UpdateUserPrivacityUseCase: UpdateUserPrivacityUseCaseProtocol {

    let repository: UserProfileRepositoryProtocol

    init(repository: UserProfileRepositoryProtocol) {
        self.repository = repository
    }

    func execute(privacity: Bool) async throws -> UserProfileModel {
        return try await repository.updateUserPrivacity(privacity: privacity).async()
    }
}
