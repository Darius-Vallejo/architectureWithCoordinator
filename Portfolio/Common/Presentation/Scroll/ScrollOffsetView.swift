//
//  ScrollOffsetView.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 7/01/25.
//

import SwiftUI

struct ScrollOffsetView<Content: View>: View {
    let content: Content
    let onScroll: (CGFloat) -> Void
    let onRefresh: (() -> Void)?

    init(
        @ViewBuilder content: () -> Content,
        onScroll: @escaping (CGFloat) -> Void,
        onRefresh: (() -> Void)? = nil
    ) {
        self.content = content()
        self.onScroll = onScroll
        self.onRefresh = onRefresh
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            GeometryReader { geometry in
                Color.clear
                    .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .global).minY)
            }
            .frame(height: 0) // Invisible frame to track scroll offset

            content
        }
        .refreshable {
            onRefresh?()
        }
        .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: onScroll)
    }
}
