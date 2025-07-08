//
//  FormComponent.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 23/12/24.
//

import Combine

protocol FormComponent: AnyObject {
    associatedtype Input

    var componentName: String { get }
    var data: Input { get set }
    var inputError: String? { get set }
    var validator: any FormDataValidator<Input> { get }
    var isComponentReadySubject: CurrentValueSubject <Bool, Never> { get }
}

extension FormComponent {
    func validate(newValue: Input) {
        do {
            try validator.validate(value: newValue)
            inputError = nil
            isComponentReadySubject.send(true)
        } catch {
            let errorMessage = if let formError = (error as? FormDataErrorType)?.errorDescription {
                formError
            } else {
                error.localizedDescription
            }
            
            inputError = "Error in component \(componentName): \(errorMessage)"
            isComponentReadySubject.send(false)
            print("Error validating input '\(newValue)' on component \(componentName)")
        }
    }
}
