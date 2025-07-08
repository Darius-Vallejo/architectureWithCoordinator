//
//  RetriveSessionUseCase.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 23/11/24.
//

protocol RetriveSessionUseCaseProtocol {
    func execute() throws -> SessionAuthModel
}

class RetriveSessionUseCase: RetriveSessionUseCaseProtocol {
    private let sessionRepository: SessionRepositoryProtocol

    init(_ userRepository: SessionRepositoryProtocol) {
        self.sessionRepository = userRepository
    }

    func execute() throws -> SessionAuthModel {
        return try sessionRepository.getAuthSession()
    }
}

