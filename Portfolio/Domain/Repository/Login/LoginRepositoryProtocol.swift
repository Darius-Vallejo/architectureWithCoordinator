//
//  LoginRepositoryProtocol.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 22/11/24.
//

import Combine

protocol LoginRepositoryProtocol {
    func loginWithGoogle(params: GoogleLoginRequestParams) -> AnyPublisher<SessionModel, NetworkError>
}
