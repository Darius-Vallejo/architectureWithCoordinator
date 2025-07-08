//
//  ViewHelpers.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 23/11/24.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    @ViewBuilder
    func roundedRectangle(cornerRadius: CGFloat,
                          borderColor: Color? = nil,
                          borderLine: CGFloat = 0) -> some View {
        if let borderColor = borderColor {
            clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: borderLine)
           )
        } else {
            clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
    }
    
    /// A modifier to show an async loading overlay on top of the view.
    /// - Parameters:
    ///   - isPresented: Binding to control the visibility of the overlay.
    ///   - message: The message to display within the overlay (default: "Loading, please wait...").
    func asyncLoadingOverlay(isPresented: Binding<Bool>, message: String = "Loading, please wait...") -> some View {
        self.modifier(AsyncLoadingModifier(isPresented: isPresented, message: message))
    }

    func hideKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
