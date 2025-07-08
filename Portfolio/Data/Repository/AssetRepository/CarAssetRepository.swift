//
//  CarAssetRepository.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 20/12/24.
//

import Combine
import Alamofire
import Foundation

class CarAssetRepository: CarAssetRepositoryProtocol {

    private let networkManager: ServicesProcol
    private var carBrandsMemory: [CarBrandDetail]
    private var carModelsMemory: [CarBrandDetail: [CarModelDetail]]
    
    init(networkManager: ServicesProcol = Services.shared) {
        self.networkManager = networkManager
        carBrandsMemory = []
        carModelsMemory = [:]
    }

    func assetsFromUser() -> AnyPublisher<[AssetDomainModel], NetworkError> {
        return networkManager
            .fetch(endPoint: AssetEndpoints.getUserAssets, type: [AssetDTO].self)
            .map { AssetDomainMapper().mapList(response: $0) }
            .eraseToAnyPublisher()
    }
    
    func loadCarMetadata() {
        Task {
            do {
                carBrandsMemory = try await getCarBrands()
            } catch {
                print("getCardBrands task failed with error: \(error)")
            }
        }
    }
    
    func getCarBrands() async throws(NetworkError) -> [CarBrandDetail] {
        if !carBrandsMemory.isEmpty {
            return carBrandsMemory
        }
        
        do {
            let arrayDTO = try await networkManager.fetch(
                endPoint: AssetEndpoints.getCarBrands,
                type: [CarBrandDTO].self
            ).async()
            
            // Server could return repeated names, so we removed duplicated.
            let result = Set<CarBrandDetail>(CarBrandMapper().mapList(response: arrayDTO))
                .map { $0 }
                .sorted { $0.name < $1.name }
            carBrandsMemory = result
            
            return result
        } catch {
            throw makeNetworkError(from: error)
        }
    }
    
    func getCarModels(for brand: CarBrandDetail) async throws(NetworkError) -> [CarModelDetail] {
        if let carModelsByBrand = carModelsMemory[brand] {
            return carModelsByBrand
        }
        
        do {
            let arrayDTO = try await networkManager.fetch(
                endPoint: AssetEndpoints.getCarModels(brand: brand.name),
                type: [CarModelDTO].self
            ).async()
            
            // Server could return repeated names, so we removed duplicated.
            let result = Set<CarModelDetail>(CarModelMapper().mapList(response: arrayDTO))
                .map { $0 }
                .sorted { $0.name < $1.name }
            carModelsMemory[brand] = result
            
            return result
        } catch {
            throw makeNetworkError(from: error)
        }
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

        for (index, imageData) in model.imagesContent.enumerated() {
            multipartData.append(
                imageData,
                withName: "images",
                fileName: "image\(index).jpg",
                mimeType: "image/jpeg"
            )
        }
        
        if let make = model.assetDetails.make?.data(using: .utf8) {
            multipartData.append(make, withName: "make")
        }
        
        if let carModel = model.assetDetails.model?.data(using: .utf8) {
            multipartData.append(carModel, withName: "model")
        }
        
        if let vin = model.assetDetails.vin?.data(using: .utf8) {
            multipartData.append(vin, withName: "vin")
        }
        
        if let mileage = model.assetDetails.mileage, let mileageData = "\(mileage)".data(using: .utf8) {
            multipartData.append(mileageData, withName: "mileage")
        }

        if let tag = model.tag.rawValue.data(using: .utf8) {
            multipartData.append(tag, withName: "tag")
        }
        
        do {
            let result: NoContentDto = try await networkManager.multipartRequest(
                endPoint: AssetEndpoints.saveCarAsset,
                multipart: multipartData,
                type: NoContentDto.self
            ).async()
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
