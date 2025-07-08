//
//  FontUtility.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 23/11/24.
//


import SwiftUI

struct FontUtility {
    static func registerFont() {
        FontFamily.allCases.forEach { family in
            FontStyle.allCases.forEach {
                registerFont(bundle: .main,
                             fontName: FontUtility.getFontName(family, style: $0),
                             fontExtension: "ttf")
            }
        }
    }

    fileprivate static func registerFont(bundle: Bundle,
                                         fontName: String,
                                         fontExtension: String) {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension) else {
                  return
              }

        var error: Unmanaged<CFError>?

        CTFontManagerRegisterFontsForURL(fontURL as CFURL, .persistent, &error)
     //   CTFontManagerRegisterGraphicsFont(font, &error)
    }
}

extension FontUtility {
    static func getFontName(_ family: FontFamily, style: FontStyle) -> String {
        return String(format: "%@-%@", family.rawValue, style.rawValue)
    }
}

extension FontUtility {
    static func getSystemFont(style: FontStyle, size: CGFloat) -> Font {
        return style == .italic
        ? .system(size: size, weight: style.getWeight()).italic()
        : .system(size: size, weight: style.getWeight())
    }
}
