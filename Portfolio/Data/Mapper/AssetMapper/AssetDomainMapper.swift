//
//  AssetDomainMapper.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 20/12/24.
//
import Foundation

struct AssetDomainMapper: DomainMapper {
    func mapValue(response: AssetDTO) -> AssetDomainModel {
        let price = Double(response.price ?? "")
        return AssetDomainModel(
            id: response.id,
            type: AssetType(rawValue: response.type ?? "") ?? .car,
            price: price ?? 0,
            isPrivate: response.isPrivate ?? false,
            costsPerMonth: Double(response.costsPerMonth ?? "") ?? 0,
            title: response.title ?? "",
            description: response.description ?? "",
            dateOfPurchase: Date().fromString(response.dateOfPurchase ?? ""),
            imagesURL: response.images ?? [],
            imagesContent: [],
            tag: TagForMarket(rawValue: response.tag ?? "") ?? .offMarket,
            assetDetails: mapAssetDetails(response: response.assetDetails)
        )
    }

    private func mapAssetDetails(response: AssetDetailsDTO?) -> AssetDetails {
        return AssetDetails(
            make: response?.make ?? "",
            model: response?.model ?? "",
            vin: response?.vin ?? "",
            mileage: response?.mileage ?? 0
        )
    }
}
