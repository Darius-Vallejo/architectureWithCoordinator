//
//  UpdateUserDescriptionUseCase.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 4/12/24.
//


import Combine
import Alamofire

class UpdateUserDescriptionUseCase: UpdateUserDescriptionUseCaseProtocol {
    let repository: UserProfileRepositoryProtocol

    init(repository: UserProfileRepositoryProtocol) {
        self.repository = repository
    }

    func execute(description: String) async throws -> UserProfileModel {
        return try await repository.updateUserDescription(description: description).async()
    }
}
