//
//  CreateNewAssetViewModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 28/11/24.
//

import Combine

class CreateNewAssetViewModel: ObservableObject {
    var assetType: AssetType

    init(assetType: AssetType) {
        self.assetType = assetType
    }
}

/// Setup for title
extension CreateNewAssetViewModel {
    var titleBase: String {
        return "Add new"
    }

    var relativeTitle: String {
        return assetType.rawValue
    }

    var title: String {
        "\(titleBase) \(relativeTitle)"
    }
}

extension CreateNewAssetViewModel {
    enum Navigation: Hashable {
        case uploadImages
        case takeImage
        case selectedImages
        case form
    }
}
