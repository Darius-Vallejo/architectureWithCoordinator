//
//  CustomTextFieldViewModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 23/12/24.
//

import Combine

class CustomTextFieldViewModel: ObservableObject, FormComponent {
        
    @Published
    var data: String {
        didSet {
            validate(newValue: data)
        }
    }
    @Published
    var inputError: String?
    
    let isComponentReadySubject: CurrentValueSubject<Bool, Never>
    let placeholder: String
    let validator: any FormDataValidator<String>
    let componentName: String
        
    init(
        data: String,
        placeholder: String,
        componentName: String,
        validator: any FormDataValidator<String>
    ) {
        self.data = data
        self.placeholder = placeholder
        self.validator = validator
        self.componentName = componentName
        isComponentReadySubject = .init(false)
        //validate(newValue: data)
    }
}
