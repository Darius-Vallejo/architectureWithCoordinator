//
//  FetchImagesFromLibraryUseCaseProtocol.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 29/11/24.
//



protocol FetchImagesFromLibraryUseCaseProtocol {
    func execute(page: Int, isGettingFullImage: Bool) async throws -> [RecentImage]
}