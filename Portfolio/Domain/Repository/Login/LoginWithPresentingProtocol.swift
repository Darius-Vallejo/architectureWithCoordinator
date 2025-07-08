//
//  LoginWithPresentingProtocol.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 22/11/24.
//

import UIKit

protocol LoginWithPresentingProtocol {
    func signIn(presenting: UIViewController) async throws -> LoginModel
}
