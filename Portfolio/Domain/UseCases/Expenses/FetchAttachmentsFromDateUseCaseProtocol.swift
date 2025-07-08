//
//  FetchAttachmentsFromDateUseCaseProtocol.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 28/01/25.
//

import Combine
import Foundation

protocol FetchAttachmentsFromDateUseCaseProtocol {
    func execute(date: Date, assetId: Int) -> AnyPublisher<[AttachmentDomainModel], NetworkError>
}

class FetchAttachmentsFromDateUseCase: FetchAttachmentsFromDateUseCaseProtocol {
    private let repository: AttachmentRepositoryProtocol

    init(repository: AttachmentRepositoryProtocol) {
        self.repository = repository
    }

    func execute(date: Date, assetId: Int) -> AnyPublisher<[AttachmentDomainModel], NetworkError> {
        repository.fetchAttachments(from: date, assetId: assetId)
    }
}
