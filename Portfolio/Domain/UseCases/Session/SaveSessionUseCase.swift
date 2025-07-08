//
//  SaveSessionUseCase.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 22/11/24.
//


class SaveSessionUseCase: SaveSessionProtocol {
    private let sessionRepository: SessionRepositoryProtocol

    init(_ userRepository: SessionRepositoryProtocol) {
        self.sessionRepository = userRepository
    }

    func execute(session: SessionModel, authSession: SessionAuthModel? = nil) throws {
        do {
            try sessionRepository.saveSession(session: session)
            if (authSession != nil) {
                try sessionRepository.saveAuthSession(session: authSession!)
            }
        }
    }
}