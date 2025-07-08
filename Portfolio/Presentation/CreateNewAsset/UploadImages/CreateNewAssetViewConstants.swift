//
//  CreateNewAssetViewConstants.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 20/12/24.
//

import SwiftUI

struct CreateNewAssetViewConstants {
    struct Dimensions {
        static let vStackSpacing: CGFloat = 8
        static let topPadding: CGFloat = 16
        static let horizontalPadding: CGFloat = 16
        static let navigationLinkTopPadding: CGFloat = 8
        static let gridColumns = [GridItem(.flexible()), GridItem(.flexible())]
    }

    struct Colors {
        static let headerTitleColor = Color.blackPortfolio
        static let iconColor = Color.yellowPortfolio
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
