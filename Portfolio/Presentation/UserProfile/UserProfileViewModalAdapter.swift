//
//  UserProfileViewModalAdapter.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 30/11/24.
//

import Combine

class UserProfileViewModalAdapter: ObservableObject {
    @Published var newAseetModalObject: ModalAdapter<NewAssetModel> = .init()
    @Published var assetDetailObject: ModalAdapter<AssetDomainModel> = .init()

    func a() {
        assetDetailObject.presentModal
    }
}
