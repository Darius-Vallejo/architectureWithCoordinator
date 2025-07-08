//
//  RetriveUserProfileUseCaseProtocol.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 2/12/24.
//


protocol RetrieveUserProfileUseCaseProtocol {
    func execute() async throws -> UserProfileModel
}
