//
//  CreateNewAssetForTypeConstants.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 19/12/24.
//

import SwiftUI

struct CreateNewAssetForTypeConstants {
    struct Dimensions {
        static let iconBackgroundSize: CGFloat = 36
        static let iconSize: CGFloat = 16
        static let rowHorizontalPadding: CGFloat = 8
        static let rowHeight: CGFloat = 58
        static let titleVerticalPadding: CGFloat = 13
        static let iconBackgroundOpacity: CGFloat = 0.2
        static let buttonVerticalPadding: CGFloat = 32
        static let horizontalPadding: CGFloat = 16
    }

    struct Colors {
        static let toggleIconColor = Color.yellowPortfolio
        static let toggleIconForegroundColor = Color.blackPortfolio
        static let titleColor = Color.blackPortfolio
        static let toggleTintColor = Color.yellowPortfolio
        static let backgroundColor = Color.white
    }

    struct Fonts {
        static let titleFont = Font.interDisplayMedium14
    }

    struct Assets {
        struct Icons {
            static let settingsAccount = "settingsAccountIcon"
            // Add other icons as needed
        }
    }

    struct StaticOptions {
        static let makes = ["BMW", "Mazda", "Mercedes", "Toyota"]
        static let marketTags = TagForMarket.allCases.map { $0.title }
    }
}
