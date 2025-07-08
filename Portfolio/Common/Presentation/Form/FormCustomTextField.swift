//
//  FormCustomTextField.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 23/12/24.
//

import Combine
import SwiftUI

struct FormCustomTextField: View {

    @ObservedObject
    var viewModel: CustomTextFieldViewModel
    var axis: Axis = .horizontal
    var type: CustomTextField.TextfieldType = .text

    var body: some View {
        CustomTextField(text: $viewModel.data, placeholder: viewModel.placeholder, axis: axis, type: type)
    }
}

#Preview {
    let viewModel = CustomTextFieldViewModel(
        data: "",
        placeholder: "Enter a value",
        componentName: "Preview Textfield",
        validator: DefaultFormInputTextValidator()
    )
    
    FormCustomTextField(viewModel: viewModel)
}
