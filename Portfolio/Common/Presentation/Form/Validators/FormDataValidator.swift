//
//  FormDataValidator.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 23/12/24.
//

import Foundation

protocol FormDataErrorType: Error, LocalizedError {

}

protocol FormDataValidator<Input> {
    associatedtype Input
    func validate(value: Input) throws
}

