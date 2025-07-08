//
//  CreateNewAssetWithSelectedImagesConstants.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 19/12/24.
//

import SwiftUI

struct CreateNewAssetWithSelectedImagesConstants {
    struct Dimensions {
        static let gridColumns = [GridItem(.flexible()), GridItem(.flexible())]
        static let vStackSpacing: CGFloat = 8
        static let topPadding: CGFloat = 16
        static let horizontalPadding: CGFloat = 16
        static let bottomPadding: CGFloat = 32
        static let buttonTopPadding: CGFloat = 8
        static let gridSpacing: CGFloat = 20
        static let imageWidth: CGFloat = 169
        static let imageHeight: CGFloat = 231
        static let imageCornerRadius: CGFloat = 10
        static let gridTopPadding: CGFloat = 10
        static let gridBottomPadding: CGFloat = 40
    }

    struct Colors {
        static let headerTitleColor = Color.blackPortfolio
        static let iconColor = Color.yellowPortfolio
        static let gridBackground = Color.white
    }

    struct Fonts {
        static let headerTitleFont = Font.newBlackTypefaceExtraBold24
        static let headerDescriptionFont = Font.newBlackTypefaceMedium12
    }

    struct Assets {
        static let libraryIcon = "settingsProfileIcon"
        static let cameraIcon = "settingsCameraIcon"
    }
}
