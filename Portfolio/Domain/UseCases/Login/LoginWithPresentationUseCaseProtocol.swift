//
//  LoginWithPresentationUseCaseProtocol.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 22/11/24.
//

import UIKit

protocol LoginWithPresentationUseCaseProtocol {
    func execute(presenting view: UIViewController) async throws -> LoginModel
}
