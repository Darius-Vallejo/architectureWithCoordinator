//
//  FontStyle.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 23/11/24.
//

import SwiftUI

enum FontStyle: String, CaseIterable {
    case regular = "Regular"
    case bold = "Bold"
    case extraBold = "ExtraBold"
    case semiBold = "Semibold"
    case medium = "Medium"
    case light = "Light"
    case italic = "Italic"

    func getWeight() -> Font.Weight {
        switch self {
        case .bold:
            return Font.Weight.bold
        case .semiBold:
            return Font.Weight.semibold
        case .medium:
            return Font.Weight.medium
        case .light:
            return Font.Weight.light
        default:
            return Font.Weight.regular
        }
    }
}

enum FontFamily: String, CaseIterable {
    case inter = "Inter"
    case molarum = "Molarum"
    case newBlackTypeface = "NewBlackTypeface"
}
