//
//  FetchAssetsUseCaseProtocol.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 20/12/24.
//

import Foundation

protocol FetchAssetsUseCaseProtocol {
    func execute() async throws -> [AssetDomainModel]
    func loadCarMetadata()
    func getCarBrands() async throws -> [CarBrandDetail]
    func getCarModels(for brand: CarBrandDetail) async throws -> [CarModelDetail]
}

