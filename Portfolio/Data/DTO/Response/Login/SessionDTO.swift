//
//  SessionDTO.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 22/11/24.
//

struct SessionDTO: Decodable {
    var accessToken: String
    var userId: String?
    var givenName: String?
    var familyName: String?
    var email: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case givenName
        case familyName
        case email
        case userId
    }

    func toDomain() -> SessionModel {
        SessionDomainMapper().mapValue(response: self)
    }
}
