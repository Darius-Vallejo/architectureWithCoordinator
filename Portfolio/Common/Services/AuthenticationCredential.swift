//
//  AuthenticationCredential.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 8/09/24.
//

import Foundation
import Alamofire


struct InterceptorAuthCredential: AuthenticationCredential {
    var token: String
    var requiresRefresh: Bool { false }
}

final class InterceptorAuthenticator: Authenticator {
    typealias Credential = InterceptorAuthCredential

    func apply(_ credential: Credential, to urlRequest: inout URLRequest) {
        urlRequest.headers.add(name: Services.HeaderConstants.auth.rawValue, value: "\(Services.HeaderConstants.bearer.rawValue) \(credential.token)")
    }

    func refresh(_ credential: Credential, for session: Alamofire.Session, completion: @escaping (Result<Credential, any Error>) -> Void) {

    }

    func didRequest(_ urlRequest: URLRequest, with response: HTTPURLResponse, failDueToAuthenticationError error: any Error) -> Bool {
        return false
    }

    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: Credential) -> Bool {
        return "\(Services.HeaderConstants.bearer.rawValue) \(credential.token)" == urlRequest.headers[Services.HeaderConstants.auth.rawValue]
    }
}
