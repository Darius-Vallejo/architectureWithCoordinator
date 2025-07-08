//
//  NavigationAdapterForAsset.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 6/12/24.
//


import SwiftUI

typealias DidCreateAssetSuccessfully = (AssetType) -> Void

class NavigationAdapterForAsset: ObservableObject {
    @Published var path: NavigationPath
    var didCreateAssetSuccessfully: DidCreateAssetSuccessfully?
    
    init(path: NavigationPath = .init(), didCreateAssetSuccessfully: DidCreateAssetSuccessfully? = nil) {
        self.path = path
        self.didCreateAssetSuccessfully = didCreateAssetSuccessfully
    }
}
