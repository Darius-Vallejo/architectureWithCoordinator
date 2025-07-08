//
//  ScrollOffsetPreferenceKey.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 7/01/25.
//

import SwiftUI

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
