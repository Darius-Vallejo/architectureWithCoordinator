//
//  NewAttachmentModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 13/01/25.
//

import Foundation

struct NewAttachmentModel: Encodable {
    var value: Double
    var type: AttachmentType
    var isCreatedAsAttachment: Bool
    var name: String
    var documents: Data?
    var date: String?
    var dateDomain: Date?
    var assetId: Int
    var attachmentAssociatedId: Int?
}
