//
//  NoContentDto.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 22/11/24.
//

import Alamofire

struct NoContentDto: Codable, EmptyResponse {

    static func emptyValue() -> NoContentDto {
        return NoContentDto.init()
    }
}
