//
//  EndpointBase.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 8/09/24.
//

import Foundation
import Alamofire

protocol EndpointBase {
    var urlString: String { get }
    var method: String { get }
    var parameters: [String: Any] { get }
    var headers: [String: String] { get }
    var encoding: ParameterEncoding { get }
}
