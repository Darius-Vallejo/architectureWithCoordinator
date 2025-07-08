//
//  LoginWithGoogleUseCase.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 22/11/24.
//

import UIKit



struct LoginWithPresentationUseCase: LoginWithPresentationUseCaseProtocol {

    var repository: LoginWithPresentingProtocol

    init(repository: LoginWithPresentingProtocol = GoogleSignInRepository()) {
        self.repository = repository
    }

    func execute(presenting view: UIViewController) async throws -> LoginModel {
        return try await repository.signIn(presenting: view)
    }
}
