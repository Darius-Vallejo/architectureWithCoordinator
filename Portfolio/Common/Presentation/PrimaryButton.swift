//
//  PrimaryButton.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 25/11/24.
//

import SwiftUI

struct PrimaryButton: View {
    var title: String
    var allowDisableBackground: Bool = true
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(PrimaryButtonConstants.Fonts.titleFont)
                .foregroundColor(PrimaryButtonConstants.Colors.titleColor)
                .frame(maxWidth: .infinity)
                .frame(height: PrimaryButtonConstants.Dimensions.height)
                .background(
                    allowDisableBackground ?
                    PrimaryButtonConstants.Colors.backgroundColor :
                    PrimaryButtonConstants.Colors.disabledBackgroundColor
                )
                .cornerRadius(PrimaryButtonConstants.Dimensions.cornerRadius)
        }
        .padding(.horizontal, PrimaryButtonConstants.Dimensions.horizontalPadding)
    }
}

#Preview {
    PrimaryButton(title: "Press Me") {
        print("Button Pressed")
    }
}
