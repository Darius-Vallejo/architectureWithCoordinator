//
//  SessionDomainMapper.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 22/11/24.
//

struct SessionDomainMapper: DomainMapper {
    func mapValue(response: SessionDTO) -> SessionModel {
        return .init(token: response.accessToken)
    }

    func mapFromDictionary(dictionary: [String: Any], tokenId: String) -> SessionModel{
        return .init(userId: dictionary[DicKeys.userId.rawValue] as? String,
                     firstName: dictionary[DicKeys.firstName.rawValue] as? String,
                     lastName: dictionary[DicKeys.lastName.rawValue] as? String,
                     email: dictionary[DicKeys.email.rawValue] as? String,
                     token: tokenId)
    }
}

extension SessionDomainMapper {
    enum DicKeys: String {
        case userId = "sub"
        case firstName = "givenName"
        case lastName = "familyName"
        case email = "email"
    }
}
