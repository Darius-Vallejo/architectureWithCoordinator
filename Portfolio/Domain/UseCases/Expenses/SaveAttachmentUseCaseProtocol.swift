//
//  SaveAttachmentUseCaseProtocol.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 13/01/25.
//


protocol SaveAttachmentUseCaseProtocol {
    func saveAttachment(_ attachment: NewAttachmentModel) async throws
}

class SaveAttachmentUseCase: SaveAttachmentUseCaseProtocol {
    private let repository: AttachmentRepositoryProtocol
    
    init(repository: AttachmentRepositoryProtocol) {
        self.repository = repository
    }
    
    func saveAttachment(_ attachment: NewAttachmentModel) async throws {
        if attachment.documents == nil {
            try await repository.saveExpenese(attachment)
        } else {
            try await repository.saveAttachment(attachment)
        }
    }
}
