//
//  SessionModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 22/11/24.
//

import Foundation

public struct SessionModel: Codable {
    var userId: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var token: String
}

