//
//  UpdateAttachmentUseCaseProtocol.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 1/02/25.
//


protocol UpdateAttachmentUseCaseProtocol {
    func execute(expenseId: Int, attachment: UpdateAttachmentModel) async throws(NetworkError) -> AttachmentDomainModel
}

class UpdateAttachmentUseCase: UpdateAttachmentUseCaseProtocol {
    private let repository: AttachmentRepositoryProtocol

    init(repository: AttachmentRepositoryProtocol) {
        self.repository = repository
    }

    func execute(expenseId: Int, attachment: UpdateAttachmentModel) async throws(NetworkError) -> AttachmentDomainModel {
        if attachment.documents != nil {
            try await repository.updateAttachment(expenseId: expenseId, attachment: attachment)
        } else {
            try await repository.updateExpense(expenseId: expenseId, attachment: attachment)
        }
    }
}
