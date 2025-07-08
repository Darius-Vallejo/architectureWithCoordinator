//
//  FetchImagesFromLibraryRepositoryProtocol.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 29/11/24.
//

import UIKit

protocol FetchImagesFromLibraryRepositoryProtocol: Sendable {
    func fetchImages(page: Int,
                     targetSize: CGSize,
                     isGettingFullImage: Bool) async throws -> [RecentImage]
}


extension FetchImagesFromLibraryRepositoryProtocol {
    private typealias Dimens = FetchImagesFromLibraryRepository.Dimensions
    func fetchImages(page: Int,
                     isGettingFullImage: Bool) async throws -> [RecentImage] {
        return try await fetchImages(page: page,
                           targetSize: CGSize(width: Dimens.targetWidth, height: Dimens.targetHeight),
                           isGettingFullImage: isGettingFullImage)
    }
}
