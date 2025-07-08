//
//  Colors.swift
//  portfolio
//
//  Created by Dario Fernando Vallejo Posada on 21/11/24.
//
import SwiftUI

extension Color {
    // Neutral Colors
    static let neutral700 = Color.init(colorName: "262625")
    static let neutral600 = Color.init(colorName: "333333")
    static let neutral500 = Color.init(colorName: "4D4D4D")
    static let neutral400 = Color.init(colorName: "666666")
    static let neutral300 = Color.init(colorName: "808080")
    static let neutral200 = Color.init(colorName: "999999")
    static let neutral150 = Color.init(colorName: "B3B3B3")
    static let neutral100 = Color.init(colorName: "CCCCCC")
    static let neutral75 = Color.init(colorName: "E6E6E6")
    static let neutral50 = Color.init(colorName: "F2F2F2")
    static let neutralGray = Color.init(colorName: "F6F6F6")
    static let neutralGray200 = Color.init(colorName: "B4B4B4")
    static let neutralGray300 = Color.init(colorName: "969696")

    // Portfolio Colors
    static let yellowPortfolio = Color.init(colorName: "FAF55D")
    static let purplePortfolio = Color.init(colorName: "D5C4FF")
    static let blackPurplePortfolio = Color.init(colorName: "9B79F0")
    static let blackPortfolio = Color.init(colorName: "000000")
    static let greenPortfolio = Color.init(colorName: "ABF4C4")
    static let greyPortfolio = Color.init(colorName: "D9D9D9")
    static let lightGreyPortfolio = Color.init(colorName: "E9E9E9")

    // Danger Colors
    static let danger700 = Color.init(colorName: "EC2D30")
    static let danger600 = Color.init(colorName: "E34A4A")
    static let danger500 = Color.init(colorName: "EE6666")
    static let danger400 = Color.init(colorName: "F08C8C")
    static let danger300 = Color.init(colorName: "F4AAAA")
    static let danger200 = Color.init(colorName: "FFEBEE")
    static let danger100 = Color.init(colorName: "FBD9D9")
    static let danger50 = Color.init(colorName: "FEECEC")

    // Warning Colors
    static let warning700 = Color.init(colorName: "F59E0B")
    static let warning600 = Color.init(colorName: "FFB020")
    static let warning500 = Color.init(colorName: "FFC733")
    static let warning400 = Color.init(colorName: "FFDB66")
    static let warning300 = Color.init(colorName: "FFED99")
    static let warning200 = Color.init(colorName: "FFF2B3")
    static let warning100 = Color.init(colorName: "FFF7CC")
    static let warning50 = Color.init(colorName: "FFFBEB")

    // Success Colors
    static let success700 = Color.init(colorName: "2A9D59")
    static let success600 = Color.init(colorName: "3EAF70")
    static let success500 = Color.init(colorName: "5ECB85")
    static let success400 = Color.init(colorName: "80D9A1")
    static let success300 = Color.init(colorName: "A2E5BD")
    static let success200 = Color.init(colorName: "C4F2D9")
    static let success100 = Color.init(colorName: "D9F5E5")
    static let success50 = Color.init(colorName: "EDF9F3")
}


extension Color {
    init(colorName: String) {
        if UIColor(named: colorName) != nil {
            self.init(colorName)
            return
        }
        let hex = colorName.uppercased().trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

