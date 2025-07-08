//
//  Config.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 7/09/24.
//

import Foundation

struct Config {

    static var shared: Config = .init()

    lazy var baseUrl: String = {
        #if DEBUG
            return Bundle.getValyeBy(key: .urlBase) ?? ""
        #else
        return Bundle.getValyeBy(key: .urlBaseRelease) ?? ""
        #endif
    }()

    private init() {}
}
