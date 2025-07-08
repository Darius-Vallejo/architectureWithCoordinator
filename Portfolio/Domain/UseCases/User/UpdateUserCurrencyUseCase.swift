//
//  UpdateUserCurrencyUseCase.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 5/12/24.
//


class UpdateUserCurrencyUseCase: UpdateUserCurrencyUseCaseProtocol {
    let repository: UserProfileRepositoryProtocol

    init(repository: UserProfileRepositoryProtocol) {
        self.repository = repository
    }

    func execute(currency: String) async throws -> UserProfileModel {
        return try await repository.updateUserCurrency(currency: currency).async()
    }
}
