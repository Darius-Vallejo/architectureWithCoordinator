//
//  HorizontalImageCarousel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 26/12/24.
//

import SwiftUI

struct HorizontalImageCarousel: View {
    var aspecRation: CGFloat = (231 / 175)
    let height: CGFloat = 358
    let imageUrls: [URL]
    @State private var calculatedHeight: CGFloat = 0
    private var spacing: CGFloat {
        imageUrls.count > 1 ? 15 : 0
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: spacing) {
                    ForEach(imageUrls, id: \.self) { url in
                        let boundsWidth = UIScreen.main.bounds.width  - spacing
                        let widthWithSpacing = geometry.size.width - spacing
                        let aspectHeight = aspecRation * min(boundsWidth, widthWithSpacing)

                        CacheAsyncImage(
                            urlString: url.absoluteString,
                            contentMode: .fill
                        )
                        .frame(width: boundsWidth, height: aspectHeight)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                        .padding(.trailing, -spacing*0.8)
                        .if(imageUrls.isEmpty) { content in
                            content.padding(.horizontal, 10)
                        }
                        .background(GeometryReader { proxy in
                            Color.clear
                                .preference(key: ViewHeightKey.self, value: proxy.size.height)
                        })
                    }
                }
            }
            .scrollBounceBehavior(.basedOnSize)
        }
        .frame(width: UIScreen.main.bounds.width, height: calculatedHeight)
        .onPreferenceChange(ViewHeightKey.self) { height in
            calculatedHeight = height
        }
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
