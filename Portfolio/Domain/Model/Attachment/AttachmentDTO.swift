//
//  AttachmentDTO.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 14/01/25.
//

import Foundation

// MARK: - DTO
struct AttachmentDTO: Decodable {
    let id: Int
    let name: String
    let value: Double
    let date: String?
    let type: String
    let isCreatedAsAttachment: Bool
    let attachment: AttachmentFileDTO?
    let description: String?
}

struct AttachmentFileDTO: Decodable {
    let id: Int
    let url: String
}

// MARK: - Domain Model
struct AttachmentDomainModel: Identifiable {
    let id: Int /// AssetId
    let name: String
    let value: Double
    let date: Date?
    let description: String?
    let type: AttachmentType
    let isCreatedAsAttachment: Bool
    let attachmentURL: URL?
    let attachmentId: Int
}

extension AttachmentDomainModel {
    var currency: String {
        CurrentSessionHelper.shared.user?.currency.rawValue ?? CurrencyModel.usd.rawValue
    }

    var formattedPrice: String {
        return String.formatToCurrency(value, currencyCode: currency) ?? .empty
    }

}

typealias ReportDTO = [String: [String: Double]]
