//
//  UpdateUserPrivacityUseCaseProtocol.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 6/12/24.
//

protocol UpdateUserPrivacityUseCaseProtocol {
   func execute(privacity: Bool) async throws -> UserProfileModel
}
