//
//  FetchAssetsUseCase.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 20/12/24.
//

import Combine
import Foundation

class FetchAssetsUseCase: FetchAssetsUseCaseProtocol {
    private let repository: CarAssetRepositoryProtocol

    init(repository: CarAssetRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [AssetDomainModel] {
        return try await repository.assetsFromUser().async()
    }
    
    func loadCarMetadata() {
        repository.loadCarMetadata()
    }
    
    func getCarBrands() async throws -> [CarBrandDetail] {
        try await repository.getCarBrands()
    }
    
    func getCarModels(for brand: CarBrandDetail) async throws -> [CarModelDetail] {
        try await repository.getCarModels(for: brand)
    }
}
