//
//  LoginRepository.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 22/11/24.
//

import Combine

class LoginRepository: LoginRepositoryProtocol {
    var services: ServicesProcol
    init(services: ServicesProcol = Services.shared) {
        self.services = services
    }

    func loginWithGoogle(params: GoogleLoginRequestParams) -> AnyPublisher<SessionModel, NetworkError> {
        services
            .fetch(endPoint: AuthEndpoint.google(params), type: SessionDTO.self)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
}
