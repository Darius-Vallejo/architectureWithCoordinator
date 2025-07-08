//
//  NavigationAdapterForAssetDetail.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 6/01/25.
//

import SwiftUI

class NavigationAdapterForAssetDetail: ObservableObject {
    @Published var path: NavigationPath = .init()
    func popBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
}
