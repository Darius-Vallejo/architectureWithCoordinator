//
//  LotRepository.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 1/01/25.
//

import Combine
import Alamofire
import Foundation

class LotRepository: AssetRepositoryProtocol {

    private let networkManager: ServicesProcol

    init(networkManager: ServicesProcol = Services.shared) {
        self.networkManager = networkManager
    }

    func saveModel(with model: AssetDomainModel) async throws(NetworkError) {
        let multipartData = MultipartFormData()

        if let type = model.type.rawValue.data(using: .utf8) {
            multipartData.append(type, withName: "type")
        }

        if let price = "\(model.price)".data(using: .utf8) {
            multipartData.append(price, withName: "price")
        }

        if let isPrivate = "\(model.isPrivate)".data(using: .utf8) {
            multipartData.append(isPrivate, withName: "isPrivate")
        }

        if let costsPerMonth = "\(model.costsPerMonth)".data(using: .utf8) {
            multipartData.append(costsPerMonth, withName: "costsPerMonth")
        }

        if let title = model.title.data(using: .utf8) {
            multipartData.append(title, withName: "title")
        }

        if let description = model.description.data(using: .utf8) {
            multipartData.append(description, withName: "description")
        }

        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate]
        if let dateOfPurchase = model.dateOfPurchase {
            let formattedDate = dateFormatter.string(from: dateOfPurchase)
            if let dateOfPurchase = formattedDate.data(using: .utf8) {
                multipartData.append(dateOfPurchase, withName: "dateOfPurchase")
            }
        }

        if let dateOfConstruction = model.assetDetails.dateOfConstruction {
            let formattedConstructionDate = dateFormatter.string(from: dateOfConstruction)
            multipartData.append(formattedConstructionDate.data(using: .utf8)!, withName: "dateOfConstruction")
        }

        if let area = model.assetDetails.area, let areaData = "\(area)".data(using: .utf8) {
            multipartData.append(areaData, withName: "area")
        }

        if let zoning = model.assetDetails.zoning?.rawValue.data(using: .utf8) {
            multipartData.append(zoning, withName: "zoning")
        }

        if let tag = model.tag.rawValue.data(using: .utf8) {
            multipartData.append(tag, withName: "tag")
        }


        for (index, imageData) in model.imagesContent.enumerated() {
            multipartData.append(
                imageData,
                withName: "images",
                fileName: "image\(index).jpg",
                mimeType: "image/jpeg"
            )
        }

        do {
            let result: NoContentDto = try await networkManager.multipartRequest(
                endPoint: AssetEndpoints.saveLotAsset,
                multipart: multipartData,
                type: NoContentDto.self
            ).async()

            print(result)
        } catch {
            throw makeNetworkError(from: error)
        }
    }

    private func makeNetworkError(from error: Error) -> NetworkError {
        if let networkError = error as? NetworkError {
            return networkError
        } else {
            return NetworkError.unknownError(error)
        }
    }
}
