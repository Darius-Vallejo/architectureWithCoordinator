//
//  GoogleSignInRepository.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 22/11/24.
//

import UIKit
import GoogleSignIn

class GoogleSignInRepository: LoginWithPresentingProtocol {
    @MainActor
    func signIn(presenting: UIViewController) async throws -> LoginModel {
        return try await withCheckedThrowingContinuation { continuation in
            GIDSignIn.sharedInstance.signIn(withPresenting: presenting) { response, error in
                if let error = error {
                    print("Error signing in with Google: \(error.localizedDescription)")
                    continuation.resume(throwing: NetworkError.unknownError(error))
                    return
                }
                guard let user = response?.user, let token = user.idToken?.tokenString else {
                    print("User is nil")
                    continuation.resume(throwing: NetworkError.invalidResponse)
                    return
                }

                continuation.resume(returning: .init(token: token))
            }
        }
    }
}
