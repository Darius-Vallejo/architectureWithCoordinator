//
//  CustomTextField.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 25/11/24.
//


import SwiftUI

struct CustomTextField: View {

    @Binding var text: String
    var placeholder: String
    var axis: Axis = .horizontal
    var type: TextfieldType = .text

    var body: some View {
        TextField(placeholder, text: $text, axis: axis)
            .keyboardType(type.keyboardType)
            .font(CustomTextFieldConstants.Fonts.textFieldFont)
            .padding(.horizontal, CustomTextFieldConstants.Dimensions.horizontalPadding)
            .padding(.vertical, CustomTextFieldConstants.Dimensions.verticalPadding)
            .background(
                RoundedRectangle(cornerRadius: CustomTextFieldConstants.Dimensions.cornerRadius)
                    .stroke(CustomTextFieldConstants.Colors.borderColor, lineWidth: CustomTextFieldConstants.Dimensions.borderLineWidth)
            )

    }
}

extension CustomTextField {
    enum TextfieldType {
        case number
        case text
        case currency

        fileprivate var keyboardType: UIKeyboardType {
            switch self {
            case .number: return .numberPad
            case .text: return .default
            case .currency: return .decimalPad
            }
        }
    }
}

#Preview {
    @Previewable @State var text = ""

    return CustomTextField(text: $text, placeholder: "Enter text")
}
