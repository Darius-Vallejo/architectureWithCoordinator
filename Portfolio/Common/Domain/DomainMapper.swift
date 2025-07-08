//
//  Mapper.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 22/11/24.
//

protocol DomainMapper<InputType, OutputType> {
    associatedtype InputType
    associatedtype OutputType
    func mapValue(response: InputType) -> OutputType
}

extension DomainMapper {
    func mapList(response: [InputType]) -> [OutputType] {
        return response.compactMap({ mapValue(response: $0 )})
    }
}
