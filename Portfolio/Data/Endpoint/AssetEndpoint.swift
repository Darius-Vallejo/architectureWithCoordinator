//
//  AssetEndpoint.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 20/12/24.
//

import Alamofire

enum AssetEndpoints {
    // Car Endpoints
    case getCarBrands
    case getCarModels(brand: String)
    case saveCarAsset
    case saveRVAsset

    // Aircraft Endpoints
    case saveAircraftAsset

    // Boat Endpoints
    case saveBoatAsset

    // House Endpoints
    case saveHouseAsset

    // Lot Endpoints
    case saveLotAsset

    // General Asset Endpoints
    case getUserAssets
}

extension AssetEndpoints: EndpointBase {

    private var baseUrl: String {
        Config.shared.baseUrl
    }

    private var relativeURL: String {
        switch self {
        // Car Endpoints
        case .getCarBrands:
            return "makes/load"
        case .getCarModels(let brand):
            return "makes/load/models/\(brand)"
        case .saveCarAsset:
            return "assets/car"

        case .saveRVAsset:
            return "assets/rv"

        // Aircraft Endpoints
        case .saveAircraftAsset:
            return "assets/aircraft"

        // Boat Endpoints
        case .saveBoatAsset:
            return "assets/boat"

        // House Endpoints
        case .saveHouseAsset:
            return "assets/house"

        // Lot Endpoints
        case .saveLotAsset:
            return "assets/lot"

        // General Asset Endpoints
        case .getUserAssets:
            return "assets/user"
        }
    }

    var urlString: String {
        return baseUrl + relativeURL
    }

    var method: String {
        switch self {
        // GET requests
        case .getCarBrands, .getCarModels, .getUserAssets:
            return EndpointMethods.get.rawValue

        // POST requests
        case .saveCarAsset, .saveRVAsset, .saveAircraftAsset, .saveBoatAsset, .saveHouseAsset, .saveLotAsset:
            return EndpointMethods.post.rawValue
        }
    }

    var parameters: [String: Any] {
        switch self {
        case .getCarBrands,
                .getCarModels,
                .getUserAssets,
                .saveCarAsset,
                .saveRVAsset,
                .saveAircraftAsset,
                .saveBoatAsset,
                .saveHouseAsset,
                .saveLotAsset:
            return [:] // No additional parameters required for now
        }
    }

    var headers: [String: String] {
        switch self {
        case .getCarBrands, .getCarModels, .getUserAssets:
            return [:] // Default headers for GET requests
        case .saveCarAsset, .saveAircraftAsset, .saveBoatAsset, .saveHouseAsset, .saveLotAsset, .saveRVAsset:
            return ["Content-Type": "multipart/form-data"]
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .getCarBrands, .getCarModels, .getUserAssets:
            return URLEncoding.default // URL encoding for GET requests
        case .saveCarAsset, .saveAircraftAsset, .saveBoatAsset, .saveHouseAsset, .saveLotAsset, .saveRVAsset:
            return JSONEncoding.default // JSON encoding for POST requests
        }
    }
}
