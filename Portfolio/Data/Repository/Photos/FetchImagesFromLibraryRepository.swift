//
//  FetchImagesFromLibraryRepository.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 29/11/24.
//

import PhotosUI

actor FetchImagesFromLibraryRepository: FetchImagesFromLibraryRepositoryProtocol {
    private typealias Dimens = FetchImagesFromLibraryRepository.Dimensions
    var pageSize: Int

    init(pageSize: Int) {
        self.pageSize = pageSize
    }

    func fetchImages(page: Int,
                     targetSize: CGSize,
                     isGettingFullImage: Bool = false) async throws -> [RecentImage] {
           let fetchOptions = PHFetchOptions()
           fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
           fetchOptions.fetchLimit = pageSize * (page + 1)

           let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
           var images: [RecentImage] = []

           let startIndex = page * pageSize
           let endIndex = min(startIndex + pageSize, fetchResult.count)

           guard startIndex < fetchResult.count else {
               throw ImagesError.noMore
           }

           for index in startIndex..<endIndex {
               let asset = fetchResult.object(at: index)
               let imageManager = PHImageManager.default()
               let requestOptions = PHImageRequestOptions()
               requestOptions.isSynchronous = true
               requestOptions.deliveryMode = .highQualityFormat

               try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                   // Request the thumbnail image
                   imageManager.requestImage(for: asset,
                                             targetSize: targetSize,
                                             contentMode: .aspectFill,
                                             options: requestOptions) { (thumbnail, _) in
                       guard let thumbnail = thumbnail else {
                           continuation.resume(throwing: ImagesError.noMore)
                           return
                       }

                       if isGettingFullImage {
                           imageManager.requestImage(for: asset,
                                                     targetSize: PHImageManagerMaximumSize,
                                                     contentMode: .aspectFill,
                                                     options: requestOptions) { (fullImage, _) in
                               guard let fullImage = fullImage else { return }

                               images.append(RecentImage(thumbnail: thumbnail, fullImage: fullImage))
                               continuation.resume(returning: ())
                           }
                       } else {
                           images.append(RecentImage(thumbnail: thumbnail, fullImage: nil))
                           continuation.resume(returning: ())
                       }
                   }
               }
           }

            return images
       }

}

extension FetchImagesFromLibraryRepository {
    struct Dimensions {
        static let targetWidth: CGFloat = 169
        static let targetHeight: CGFloat = 231
    }
}
