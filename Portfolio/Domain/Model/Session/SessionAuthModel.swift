//
//  SessionAuthModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 22/11/24.
//
import Foundation
import JWTDecode

public struct SessionAuthModel: Codable {
    let authToken: String
    let refreshToken: String
    private let jwt: JWT?
    private enum CodingKeys: String, CodingKey {
        case authToken, refreshToken
    }

    init(authToken: String, refreshToken: String) {
        self.authToken = authToken
        self.refreshToken = refreshToken
        self.jwt = try? decode(jwt: authToken)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        authToken = try container.decode(String.self, forKey: .authToken)
        refreshToken = try container.decode(String.self, forKey: .refreshToken)
        jwt = try? decode(jwt: authToken)
    }

    func isAccessTokenExpired() -> Bool {
        return jwt?.expired ?? false
    }

    func getFullJWT() -> [String: Any] {
        return jwt?.body ?? [:]
    }
}
