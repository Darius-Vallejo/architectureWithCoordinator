//
//  TokenInterceptor.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 8/09/24.
//

import Foundation
import Alamofire

protocol TokenInterceptorProtocol {
    func getInterceptor(endpoint: EndpointBase, accessToken: String) -> RequestInterceptor?
    func getAccessToken() -> String
}

extension Services: TokenInterceptorProtocol {
    func getInterceptor(endpoint: EndpointBase, accessToken: String) -> RequestInterceptor? {
        var interceptor: RequestInterceptor?

        let authenticator = InterceptorAuthenticator()
        let credentials = InterceptorAuthCredential(token: accessToken)
        //interceptor = AuthenticationInterceptor(authenticator: authenticator)
        //interceptor = AuthenticationInterceptor<InterceptorAuthenticator>(authenticator: authenticator, credential: credentials)
        return nil
    }

    func getAccessToken() -> String {
        do {
            let session = try SessionRepository.shared.getAuthSession()
            return "\(Services.HeaderConstants.bearer.rawValue) \(session.authToken)"
        } catch {
            print("Error [with session] getAccessToken()")
            return .empty
        }
    }
}
