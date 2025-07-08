//
//  DefaultFormInputTextValidator.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 23/12/24.
//

import Foundation

struct DefaultFormInputTextValidator: FormDataValidator {
    
    enum InputForm {
        case decimal
        case integer
        case text
    }
    
    enum Errors: FormDataErrorType {
        case emptyData
        case invalidDecimalNumber
        case invalidIntegerNumber
        
        var errorDescription: String? {
            switch self {
            case .emptyData:
                return "Please enter a value."
            case .invalidDecimalNumber:
                return "Please enter a valid decimal number."
            case .invalidIntegerNumber:
                return "Please enter a valid integer number."
            }
        }
    }
    
    var inputForm: InputForm
    
    init(inputForm: InputForm = .text) {
        self.inputForm = inputForm
    }
    
    func validate(value: String) throws {
        if value.isEmpty {
            throw Errors.emptyData
        }
        
        switch inputForm {
        case .decimal:
            if !isValidNumber(value, style: .decimal) {
                throw Errors.invalidDecimalNumber
            }
        case .integer:
            if !isValidNumber(value, style: .none) {
                throw Errors.invalidIntegerNumber
            }
        default:
            break
        }
    }
    
    private func isValidNumber(
        _ string: String,
        locale: Locale = .current,
        style: NumberFormatter.Style
    ) -> Bool {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = style
        return formatter.number(from: string) != nil
    }
    
}
