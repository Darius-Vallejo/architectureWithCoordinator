//
//  ChooseFromLibrarySettingsViewConstants.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 20/12/24.
//

import SwiftUI

struct ChooseFromLibrarySettingsViewConstants {
    struct Dimensions {
        static let imageFrameWidth: CGFloat = 320
        static let imageFrameHeight: CGFloat = 320
        static let topPadding: CGFloat = 20
        static let progressScale: CGFloat = 2.0
        static let maskOpacity: CGFloat = 0.5
        static let maskHeight: CGFloat = 320
        static let circleMaskHeight: CGFloat = 315
        static let gridSpacing: CGFloat = 20
        static let gridTopPadding: CGFloat = 10
        static let pickerTopPadding: CGFloat = 10
        static let thumbnailWidth: CGFloat = 169
        static let thumbnailHeight: CGFloat = 231
        static let thumbnailCornerRadius: CGFloat = 10
        static let gridColumns = [GridItem(.flexible()), GridItem(.flexible())]
    }

    struct Behavior {
        static let allowsHitTesting = true
    }
}
