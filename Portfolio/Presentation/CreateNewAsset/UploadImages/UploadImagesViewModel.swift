//
//  UploadImagesViewModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 29/11/24.
//


import Combine
import PhotosUI
import SwiftUI

class UploadImagesViewModel: ObservableObject {
    @Published var recentImages: [RecentImage] = []
    @Published var selectedImages: Set<UUID> = []
    @Published var selectedItems: [PhotosPickerItem] = []
    @Published var currentPage: Int
    @Published var status: PHAuthorizationStatus = .notDetermined

    var fetchImageUseCase: FetchImagesFromLibraryUseCaseProtocol

    init(fetchImageUseCase: FetchImagesFromLibraryUseCaseProtocol = FetchImagesFromLibraryUseCase(repository: FetchImagesFromLibraryRepository(pageSize: 10)),
         currentPage: Int = 0) {
        self.fetchImageUseCase = fetchImageUseCase
        self.currentPage = currentPage
    }

    func addImageToSelectedList(image: UIImage) {
        let takenImage = RecentImage(thumbnail: image, fullImage: image)
        let recentOnes = recentImages
        recentImages = [takenImage]
        recentImages.append(contentsOf: recentOnes)
        selectedImages.insert(takenImage.id)
    }

    func addImageToSelectedList(images: [UIImage]) {
        let newImages = images.map { image in
            RecentImage(thumbnail: image, fullImage: image)
        }
        let recentOnes = recentImages
        recentImages = newImages
        recentImages.append(contentsOf: recentOnes)
        selectedImages = selectedImages.union(newImages.map(\.id))
    }

    func getSelectedImages() -> [RecentImage] {
        recentImages.filter { selectedImages.contains($0.id) }
    }

    func resetSelectedImages() {
        selectedImages.removeAll()
    }

    func selectImage(id: UUID) {
        if selectedImages.contains(id) {
            selectedImages.remove(id)
        } else {
            selectedImages.insert(id)
        }
    }

    func checkIfImageIsSelected(image: RecentImage) -> Bool {
        return selectedImages.contains(image.id)
    }

    @MainActor
    func loadNextPage() {
        currentPage += 1
        loadPhotos()
    }

    @MainActor
    func loadPhotos() {
        if .authorized == status || .limited == status {
            fetchRecentImages()
        } else {
            fetchRecentImages()
        }
    }

    @MainActor
    private func fetchRecentImages() {
        Task {
            do {
                let images = try await fetchImageUseCase.execute(page: currentPage, isGettingFullImage: false)
                recentImages.append(contentsOf: images)
            } catch {
                print("Error")
            }
        }
    }

    private func requestPhotoLibraryPermission() {
        PHPhotoLibrary.requestAuthorization {[unowned self] status in
            switch status {
            case .authorized, .limited:
                Task { @MainActor in
                    self.fetchRecentImages()
                }
                print("Access granted to photo library.")
            case .denied, .restricted:
                print("Access denied to photo library.")
            case .notDetermined:
                print("Permission not determined yet.")
            @unknown default:
                print("Unknown authorization status.")
            }
        }
    }
}
