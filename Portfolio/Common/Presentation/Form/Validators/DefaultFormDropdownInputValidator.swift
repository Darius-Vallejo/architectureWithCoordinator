//
//  DefaultFormDropdownInputValidator.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 23/12/24.
//

import Foundation

struct DefaultFormDropdownInputValidator: FormDataValidator {
    
    enum Errors: FormDataErrorType {
        case emptyData
        
        var errorDescription: String? {
            switch self {
            case .emptyData:
                return "Please enter a value."
            }
        }
    }
    
    func validate(value: DropdownItem) throws {
        if value.value.isEmpty {
            throw Errors.emptyData
        }
    }
    
}
