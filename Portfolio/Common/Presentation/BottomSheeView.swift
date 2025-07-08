//
//  BottomSheeView.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 25/11/24.
//

import SwiftUI

struct BottomSheeView<ContentEmbedded: View>: ViewModifier {
    @Binding var showSheet: Bool
    @State private var sheetHeight: CGFloat = .zero
    var contentEmbedded: ContentEmbedded

    func body(content: Content) -> some View {
        content
        .sheet(isPresented: $showSheet) {
            VStack {
                contentEmbedded
            }
            .padding()
            .overlay {
                GeometryReader { geometry in
                    Color.clear.preference(key: InnerHeightPreferenceKey.self, value: geometry.size.height)
                }
            }
            .onPreferenceChange(InnerHeightPreferenceKey.self) { newHeight in
                sheetHeight = newHeight
            }
            .presentationDetents([.height(sheetHeight)])
        }
    }
}

struct InnerHeightPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    func bottomSheet<Content: View>(showSheet: Binding<Bool>, view: Content) -> some View {
        modifier(BottomSheeView(showSheet: showSheet, contentEmbedded: view))
    }
}
