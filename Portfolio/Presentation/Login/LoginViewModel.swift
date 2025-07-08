//
//  LoginViewModel.swift
//  portfolio
//
//  Created by Dario Fernando Vallejo Posada on 13/11/24.
//

import Combine
import UIKit
import Foundation


class LoginViewModel: ObservableObject {

    @Published var isLoading = false
    @Published var isLoggedIn: Bool
    @Published var errorService = false
    private var saveSessionUseCase: SaveSessionProtocol
    private var googleLogin: LoginWithPresentationUseCaseProtocol
    private var loginWithToken: LoginWithTokenUseCaseProtocol


    init(isLoggedIn: Bool = false,
         saveSessionUseCase: SaveSessionProtocol = SaveSessionUseCase(SessionRepository.shared),
         googleLogin: LoginWithPresentationUseCaseProtocol = LoginWithPresentationUseCase(repository: GoogleSignInRepository()),
         loginWithToken: LoginWithTokenUseCaseProtocol = LoginWithTokenUseCase(repository: LoginRepository())) {
        self.isLoggedIn = isLoggedIn
        self.saveSessionUseCase = saveSessionUseCase
        self.googleLogin = googleLogin
        self.loginWithToken = loginWithToken
    }

    @MainActor
    func signInWithGoogle(getRoot: @escaping () -> UIViewController) {
        Task {
            do {
                isLoading = true
                let loginModel = try await googleLogin.execute(presenting: getRoot())
                let finalToken = try await loginWithToken.execute(token: loginModel.token)
                saveSession(model: finalToken)
                isLoading = false
            } catch {
                print(error)
                errorService = true
                isLoading = false
            }
        }
    }

    func saveSession(model: SessionModel) {
        do {
            let sessionToken = SessionAuthModel(
                authToken: model.token,
                refreshToken: "")
            try saveSessionUseCase.execute(
                session: model,
                authSession: sessionToken
            )
            let session = sessionToken.getFullJWT()
            let sessionModel = SessionDomainMapper().mapFromDictionary(dictionary: session, tokenId: model.token)
            CurrentSessionHelper.shared.session = sessionModel
            isLoggedIn = true
        } catch {
            errorService = true
        }
    }

}
