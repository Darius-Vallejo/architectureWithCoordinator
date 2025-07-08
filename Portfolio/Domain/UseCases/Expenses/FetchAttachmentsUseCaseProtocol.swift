//
//  FetchAttachmentsUseCaseProtocol.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 14/01/25.
//
import Combine

protocol FetchAttachmentsUseCaseProtocol {
    func execute(assetId: Int, findAllExpenses: Bool) -> AnyPublisher<[AttachmentDomainModel], NetworkError>
}

class FetchAttachmentsUseCase: FetchAttachmentsUseCaseProtocol {
    private let repository: AttachmentRepositoryProtocol

    init(repository: AttachmentRepositoryProtocol) {
        self.repository = repository
    }

    func execute(assetId: Int, findAllExpenses: Bool) -> AnyPublisher<[AttachmentDomainModel], NetworkError> {
        return repository.fetchAttachments(assetId: assetId, findAllExpenses: findAllExpenses)
    }
}
