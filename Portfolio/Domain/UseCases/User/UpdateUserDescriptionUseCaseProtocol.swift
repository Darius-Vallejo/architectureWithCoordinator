//
//  UpdateUserDescriptionUseCaseProtocol.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 4/12/24.
//


protocol UpdateUserDescriptionUseCaseProtocol {
    func execute(description: String) async throws -> UserProfileModel
}
