//
//  CreateNewAssetWithSelectedImagesViewModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 6/12/24.
//

import SwiftUI

class CreateNewAssetWithSelectedImagesViewModel: ObservableObject {

    @Published var recentImages: [RecentImage] = []
    var assetType: AssetType

    init(recentImages: [RecentImage], assetType: AssetType) {
        self.recentImages = recentImages
        self.assetType = assetType
    }
}
