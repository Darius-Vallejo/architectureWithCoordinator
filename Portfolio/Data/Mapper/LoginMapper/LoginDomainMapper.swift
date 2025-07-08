//
//  LoginDomainMapper.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 22/11/24.
//

struct LoginDomainMapper: DomainMapper {
    func mapValue(response: LoginDTO) -> LoginModel {
        return .init(token: response.accessToken)
    }
}
