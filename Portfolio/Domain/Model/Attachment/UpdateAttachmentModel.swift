//
//  UpdateAttachmentModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 2/02/25.
//

import Foundation

struct UpdateAttachmentModel: Encodable {
    var value: Double
    var type: AttachmentType
    var name: String
    var documents: Data?
    var date: String?
    var dateDomain: Date?
    var description: String
    var attachmentAssociatedId: Int?
}
