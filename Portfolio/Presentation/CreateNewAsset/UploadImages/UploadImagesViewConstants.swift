//
//  UploadImagesViewConstants.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 19/12/24.
//

import SwiftUI

struct UploadImagesViewConstants {
    struct Dimensions {
        static let gridColumns = [GridItem(.flexible()), GridItem(.flexible())]
        static let vStackSpacing: CGFloat = 16
        static let topPadding: CGFloat = 16
        static let hStackSpacing: CGFloat = 8
        static let selectButtonWidth: CGFloat = 85
        static let selectButtonHeight: CGFloat = 34
        static let selectButtonCornerRadius: CGFloat = 48
        static let bottomPadding: CGFloat = 32
        static let horizontalPadding: CGFloat = 16
        static let gridSpacing: CGFloat = 20
        static let imageWidth: CGFloat = 169
        static let imageHeight: CGFloat = 231
        static let imageCornerRadius: CGFloat = 10
        static let selectionIndicatorSize: CGFloat = 20
        static let selectionIndicatorPadding: CGFloat = 16
        static let selectionShadowRadius: CGFloat = 0.5
        static let gridTopPadding: CGFloat = 10
    }

    struct Colors {
        static let iconColor = Color.yellowPortfolio
        static let selectButtonForeground = Color.blackPortfolio
        static let selectButtonBackground = Color.yellowPortfolio
        static let selectionStrokeColor = Color.yellowPortfolio
        static let gridBackground = Color.white
    }

    struct Fonts {
        static let selectButtonFont = Font.newBlackTypefaceSemibold12
    }

    struct Assets {
        static let takeNewImagesIcon = "settingsProfileIcon"
        static let selectImagesIcon = "selectImagesIcon"
        static let checkIcon = "createAssetCheckIcon"
    }
}
