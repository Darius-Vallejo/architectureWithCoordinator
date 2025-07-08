//
//  AuthEndpoint.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 22/11/24.
//

import Alamofire

enum AuthEndpoint {
    case google(any Encodable)
}

extension AuthEndpoint: EndpointBase {
    
    private var baseUrl: String {
        Config.shared.baseUrl + "auth/"
    }

    private var relativeURL: String {
        switch self {
        case .google: "google"
        }
    }

    var urlString: String {
        return baseUrl + relativeURL
    }
    
    var method: String {
        switch self {
        case .google: EndpointMethods.post.rawValue
        }
    }
    
    var parameters: [String : Any] {
        switch self {
        case .google(let params): params.dictionary() ?? [:]
        }
    }
    
    var headers: [String : String] {
        return [:]
    }

    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
