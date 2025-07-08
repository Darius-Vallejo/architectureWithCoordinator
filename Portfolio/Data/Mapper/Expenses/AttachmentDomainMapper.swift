//
//  AttachmentDomainMapper.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 14/01/25.
//

import Foundation

struct AttachmentDomainMapper: DomainMapper {
    func mapValue(response: AttachmentDTO) -> AttachmentDomainModel {
        .init(
            id: response.id,
            name: response.name,
            value: response.value,
            date: Date().fromString(response.date ?? ""),
            description: response.description,
            type: AttachmentType(rawValue: response.type) ?? .other,
            isCreatedAsAttachment: response.isCreatedAsAttachment,
            attachmentURL: URL(string: response.attachment?.url ?? ""),
            attachmentId: response.attachment?.id ?? -1
        )
    }

    func mapList(response: [AttachmentDTO]) -> [AttachmentDomainModel] {
        response.map { mapValue(response: $0) }
    }
}
