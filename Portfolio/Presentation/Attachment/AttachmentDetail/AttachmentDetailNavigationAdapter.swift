//
//  AttachmentDetailNavigationAdapter.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 1/02/25.
//

import SwiftUI

class AttachmentDetailNavigationAdapter: ObservableObject {
    @Published var path: NavigationPath = .init()
    func popBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func pushTo(_ navigation: AttachmentDetailViewModel.Navigation) {
        path.append(navigation)
    }
}
