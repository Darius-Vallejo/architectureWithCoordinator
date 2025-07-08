//
//  CarAssetRepositoryProtocol.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 31/12/24.
//

import Combine

protocol CarAssetRepositoryProtocol: AssetRepositoryProtocol {
    func assetsFromUser() -> AnyPublisher<[AssetDomainModel], NetworkError>
    func loadCarMetadata()
    func getCarBrands() async throws(NetworkError) -> [CarBrandDetail]
    func getCarModels(for brand: CarBrandDetail) async throws(NetworkError) -> [CarModelDetail]
}
