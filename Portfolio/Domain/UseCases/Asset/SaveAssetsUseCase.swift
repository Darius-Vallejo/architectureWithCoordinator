//
//  SaveAssetsUseCase.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 24/12/24.
//

protocol SaveAssetsUseCaseProtocol {
    func save(_ newAsset: AssetDomainModel) async throws
}

class SaveAssetsUseCase: SaveAssetsUseCaseProtocol {
    private let repository: AssetRepositoryProtocol
    
    init(repository: AssetRepositoryProtocol) {
        self.repository = repository
    }
    
    func save(_ newAsset: AssetDomainModel) async throws {
        try await repository.saveModel(with: newAsset)
    }
}
