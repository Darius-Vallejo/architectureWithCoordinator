//
//  UserEndpoint.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 2/12/24.
//

import Alamofire

enum UserEndpoint {
    case userInfo
    case updateNickname(params: UpdateUserNicknameDTO)
    case updateDescription(params: UpdateUserDescriptionDTO)
    case updateCurrency(params: UpdateUserCurrencyDTO)
    case updatePrivacity(params: UpdateUserPrivacityDTO)
    case uploadProfileImage(params: UploadUserImageDTO)
}

extension UserEndpoint: EndpointBase {

    private var baseUrl: String {
        Config.shared.baseUrl + "users/"
    }

    private var relativeURL: String {
        switch self {
        case .userInfo:
            return "profile"
        case .updateNickname:
            return "profile/nickname"
        case .updateDescription:
            return "profile/description"
        case .updateCurrency:
            return "profile/currency"
        case .updatePrivacity:
            return "profile/privacity"
        case .uploadProfileImage:
            return "profile/upload"
        }
    }

    var urlString: String {
        return baseUrl + relativeURL
    }

    var method: String {
        switch self {
        case .userInfo:
            return EndpointMethods.get.rawValue
        case .updateNickname,
                .updateDescription,
                .updateCurrency,
                .updatePrivacity:
            return EndpointMethods.put.rawValue
        case .uploadProfileImage:
            return EndpointMethods.post.rawValue
        }
    }

    var parameters: [String : Any] {
        switch self {
        case .updateNickname(let params):
            return params.dictionary() ?? [:]
        case .updateDescription(let params):
            return params.dictionary() ?? [:]
        case .updateCurrency(let params):
            return params.dictionary() ?? [:]
        case .updatePrivacity(let params):
            return params.dictionary() ?? [:]
        case .uploadProfileImage(let params):
            return params.dictionary() ?? [:]
        default:
            return [:]
        }
    }

    var headers: [String : String] {
        switch self {
        case .uploadProfileImage:
            return ["Content-Type": "multipart/form-data"]
        default:
            return [:]
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .userInfo:
            return URLEncoding.default
        case .updateNickname,
                .updateDescription,
                .updateCurrency,
                .updatePrivacity,
                .uploadProfileImage:
            return JSONEncoding.default
        }
    }
}
