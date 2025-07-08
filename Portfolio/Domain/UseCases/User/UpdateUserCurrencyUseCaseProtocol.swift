//
//  UpdateUserCurrencyUseCaseProtocol.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 5/12/24.
//


protocol UpdateUserCurrencyUseCaseProtocol {
   func execute(currency: String) async throws -> UserProfileModel
}
