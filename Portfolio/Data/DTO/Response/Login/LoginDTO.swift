//
//  LoginDTO.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 22/11/24.
//

struct LoginDTO: Decodable {
    var accessToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }

    func toDomain() -> LoginModel {
        LoginDomainMapper().mapValue(response: self)
    }
}
