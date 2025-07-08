//
//  DeleteExpenseUseCaseProtocol.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 30/01/25.
//

import Combine

protocol DeleteExpenseUseCaseProtocol {
    func execute(id: Int) -> AnyPublisher<Void, NetworkError>
}

class DeleteExpenseUseCase: DeleteExpenseUseCaseProtocol {
    private let repository: AttachmentRepositoryProtocol

    init(repository: AttachmentRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: Int) -> AnyPublisher<Void, NetworkError> {
        repository.deleteExpense(id: id)
    }
}
