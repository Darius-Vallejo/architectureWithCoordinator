//
//  SettingRowConstants.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 25/11/24.
//

import SwiftUI

struct SettingRowConstants {

    struct Dimensions {
        static let iconBackgroundSize: CGFloat = 32
        static let iconSize: CGFloat = 14
        static let nextIconSize: CGFloat = 16
        static let titleVerticalPadding: CGFloat = 13
        static let horizontalPadding: CGFloat = 8
        static let rowHeight: CGFloat = 58
    }

    struct Colors {
        static let iconBackgroundOpacity: Double = 0.2
        static let iconForegroundColor = Color.blackPortfolio
        static let titleColor = Color.blackPortfolio
        static let nextIconColor = Color.blackPortfolio
    }

    struct Fonts {
        static let titleFont = Font.interDisplayMedium14
    }

    struct Assets {
        static let goNext = "goNextViewIcon"
    }
}
