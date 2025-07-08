//
//  FetchImagesFromLibraryUseCase.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 29/11/24.
//

struct FetchImagesFromLibraryUseCase: FetchImagesFromLibraryUseCaseProtocol {

    var repository: FetchImagesFromLibraryRepositoryProtocol

    func execute(page: Int, isGettingFullImage: Bool) async throws -> [RecentImage] {
        let images = try await repository.fetchImages(page: page, isGettingFullImage: isGettingFullImage)
        return images
    }
}
