//
//  GoogleLoginRequestParams.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 22/11/24.
//

struct GoogleLoginRequestParams: Codable {
    var idToken: String
    var authorizationCode: String = ""
}
