//
//  BundleExtension.swift
//  portfolio
//
//  Created by Dario Fernando Vallejo Posada on 17/11/24.
//

import Foundation

extension Bundle {
    enum ResourceName: String {
        case google = "GoogleService-Info"

        enum ResourceType: String {
            case plist
        }

        var currentType: String {
            switch self {
            case .google:
                return ResourceType.plist.rawValue
            }
        }
    }

    enum MainKey: String {
        case urlBase = "URL_BASE_DEBUG"
        case urlBaseRelease = "URL_BASE_RELEASE"
    }

    func path(forResource resource: ResourceName) -> [String: Any] {
        if let path = path(forResource: resource.rawValue, ofType: resource.currentType),
           let data = NSDictionary(contentsOfFile: path) {
            return data as? [String : Any] ?? [:]
        }
        print("GoogleService-Info.plist not found or unable to load.")
        return [:]
    }

    static func getValyeBy(key: MainKey) -> String? {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? String else {
            return nil
        }

        return apiKey
    }

}
