//
//  NetworkError.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 7/09/24.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case networkError(AFError)
    case unknownError(Error)
    case invalidResponse
    case invalidData
}
