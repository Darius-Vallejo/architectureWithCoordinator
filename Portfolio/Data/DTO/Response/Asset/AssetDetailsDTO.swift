//
//  AssetDetailsDTO.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 20/12/24.
//

import Foundation

public struct AssetDetailsDTO: Codable {
    public let make: String?
    public let model: String?
    public let vin: String?
    public let mileage: Int?
}

struct AssetDTO: Decodable {
    public let id: Int
    public let type: String?
    public let price: String?
    public let isPrivate: Bool?
    public let costsPerMonth: String?
    public let title: String?
    public let description: String?
    public let dateOfPurchase: String?
    public let images: [URL]?
    public let tag: String?
    public let assetDetails: AssetDetailsDTO?

    func toDomain() -> AssetDomainModel {
        AssetDomainMapper().mapValue(response: self)
    }
}


extension AssetDTO {
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case price
        case isPrivate
        case costsPerMonth
        case title
        case description
        case dateOfPurchase
        case images
        case tag
        case assetDetails = "asset"
    }
}

extension AssetDetailsDTO {
    enum CodingKeys: String, CodingKey {
        case make
        case model
        case vin
        case mileage
    }
}
