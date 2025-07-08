//
//  UpdateUserNicknameUseCaseProtocol.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 3/12/24.
//


protocol UpdateUserNicknameUseCaseProtocol {
    func execute(nickname: String) async throws -> UserProfileModel
}
