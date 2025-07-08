//
//  AssetDomainModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 20/12/24.
//

import Foundation

public struct AssetDomainModel: Identifiable {
    public let id: Int
    public let type: AssetType
    public let price: Double
    public let isPrivate: Bool
    public let costsPerMonth: Double
    public let title: String
    public let description: String
    public let dateOfPurchase: Date?
    public let imagesURL: [URL]
    public let imagesContent: [Data]
    public let tag: TagForMarket
    public let assetDetails: AssetDetails
}

public struct AssetDetails {
    public var make: String?
    public var model: String?
    public var vin: String? // For cars
    public var tailNumber: String? // For aircraft
    public var mileage: Int? // For cars
    public var hoursFlown: Int? // For aircraft
    public var HIN: String? // For boats
    public var length: Double? // For boats
    public var dateOfConstruction: Date? // For houses and lots
    public var area: Double? // For houses and lots
    public var zoning: ZoningInformation? // For lots
}

public struct CarBrandDetail: Identifiable, Hashable {
    public let id: String
    public let name: String
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    public static func == (lhs: CarBrandDetail, rhs: CarBrandDetail) -> Bool {
        lhs.name == rhs.name
    }
}

public struct CarModelDetail: Identifiable, Hashable {
    public let id: Int
    public let name: String
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    public static func == (lhs: CarModelDetail, rhs: CarModelDetail) -> Bool {
        lhs.name == rhs.name
    }
}
