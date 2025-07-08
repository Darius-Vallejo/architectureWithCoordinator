//
//  RemoveSessionUseCaseProtocol.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 2/12/24.
//


protocol RemoveSessionUseCaseProtocol {
    func execute() throws
}

class RemoveSessionUseCase: RemoveSessionUseCaseProtocol {
    private let sessionRepository: SessionRepositoryProtocol

    init(_ userRepository: SessionRepositoryProtocol) {
        self.sessionRepository = userRepository
    }

    func execute() throws  {
        return try sessionRepository.deleteSession()
    }
}