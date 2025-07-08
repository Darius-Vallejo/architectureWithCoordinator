//
//  LoginWithTokenUseCase.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 22/11/24.
//

protocol LoginWithTokenUseCaseProtocol {
    func execute(token: String) async throws -> SessionModel
}

class LoginWithTokenUseCase: LoginWithTokenUseCaseProtocol {

    let repository: LoginRepositoryProtocol

    init(repository: LoginRepositoryProtocol) {
        self.repository = repository
    }

    func execute(token: String) async throws -> SessionModel {
        return try await repository
            .loginWithGoogle(params: .init(idToken: token))
            .async()
    }
}
