//
//  LoginViewConstants.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 22/11/24.
//

import SwiftUI

struct LoginViewConstants {
    struct Dimensions {
        static let mainVerticalSpacing: CGFloat = 20
        static let buttonWidth: CGFloat = 358
        static let buttonHeight: CGFloat = 60
        static let cornerRadius: CGFloat = 12
        static let bottonSpacings: CGFloat = 12
        static let titlesSpacing: CGFloat = 8
        static let bottomPaddingForTitles: CGFloat = 3
        static let bottomPaddingForLoading: CGFloat = 200
    }

    struct Strings {
        static let welcomeBack = String.localized(.welcomeBack)
        static let welcomeBackDetail = String.localized(.welcomeBackDetail)
        static let gmailLogin = String.localized(.gmailLogin)
        static let appleIdLogin = String.localized(.appleIdLogin)
    }

    struct Colors {
        static let mainBlack = Color.blackPortfolio
        static let main = Color.yellowPortfolio
    }

    struct Assets {
        static let apple = "appleIcon"
        static let google = "googleIcon"
        static let main = "pIcon"
    }
}
