//
//  BannerActionModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 12/12/24.
//

import Combine

class BannerActionModel: ObservableObject {
    @Published var message: String = ""
    @Published var shouldShow: Bool = false
    @Published var type: BannerType = .error
}
