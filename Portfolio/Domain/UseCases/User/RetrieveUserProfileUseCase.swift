//
//  RetrieveUserProfileUseCase.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 2/12/24.
//

class RetrieveUserProfileUseCase: RetrieveUserProfileUseCaseProtocol {

    let repository: UserProfileRepositoryProtocol

    init(repository: UserProfileRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> UserProfileModel {
        return try await repository
            .userInfo()
            .async()
    }
}
