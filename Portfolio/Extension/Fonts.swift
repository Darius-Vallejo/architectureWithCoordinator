//
//  Fonts.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 23/11/24.
//

import SwiftUI

extension Font {
    static let newBlackTypefaceLight16 = Font.font(of: .newBlackTypeface, style: .light , size: 16)
    static let newBlackTypefaceRegular16 = Font.font(of: .newBlackTypeface, style: .regular , size: 16)
    static let newBlackTypefaceMedium16 = Font.font(of: .newBlackTypeface, style: .medium , size: 16)
    static let newBlackTypefaceRegular12 = Font.font(of: .newBlackTypeface, style: .regular , size: 12)
    static let newBlackTypefaceMedium12 = Font.font(of: .newBlackTypeface, style: .medium , size: 12)
    static let newBlackTypefaceSemibold12 = Font.font(of: .newBlackTypeface, style: .semiBold , size: 12)
    static let newBlackTypefaceSemibold16 = Font.font(of: .newBlackTypeface, style: .semiBold , size: 16)
    static let newBlackTypefaceSemibold28 = Font.font(of: .newBlackTypeface, style: .semiBold , size: 28)
    static let newBlackTypefaceSemiBold32 = Font.font(of: .newBlackTypeface, style: .semiBold, size: 32)
    static let newBlackTypefaceMedium20 = Font.font(of: .newBlackTypeface,style: .medium,size: 24)
    static let newBlackTypefaceExtraBold24 = Font.font(of: .newBlackTypeface,style: .extraBold,size: 24)
    static let newBlackTypefaceBold24 = Font.font(of: .newBlackTypeface,style: .bold,size: 24)
    static let newBlackTypefaceExtraBold28 = Font.font(of: .newBlackTypeface,style: .extraBold,size: 28)
    static let molarumMedium16 = Font.font(of: .molarum, style: .medium , size: 16)
    static let molarumSemibold16 = Font.font(of: .molarum, style: .semiBold , size: 16)
    static let molarumMedium18 = Font.font(of: .molarum, style: .medium , size: 18)
    static let interDisplayMedium10 = Font.font(of: .inter, style: .medium , size: 10)
    static let interDisplayRegular10 = Font.font(of: .inter, style: .regular , size: 10)
    static let interDisplayMedium12 = Font.font(of: .inter, style: .medium , size: 12)
    static let interDisplayRegular12 = Font.font(of: .inter, style: .regular , size: 12)
    static let interDisplayRegular14 = Font.font(of: .inter, style: .regular , size: 14)
    static let interDisplayRegular16 = Font.font(of: .inter, style: .regular , size: 16)
    static let interDisplayLight16 = Font.font(of: .inter, style: .light , size: 16)
    static let interDisplayMedium14 = Font.font(of: .inter, style: .medium , size: 14)
}

extension Font {
    static func font(of family: FontFamily = .newBlackTypeface, style: FontStyle = .regular, size: CGFloat) -> Font {
        return UIFont.init(name: FontUtility.getFontName(family, style: style), size: size) != nil
        ? .custom(FontUtility.getFontName(family, style: style), size: size)
        : FontUtility.getSystemFont(style: style, size: size)
    }
}
