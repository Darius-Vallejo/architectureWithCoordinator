//
//  SettingsDTO.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 5/12/24.
//

struct SettingsDTO: Codable {
    var nickname: String?
    var description: String?
    var privateAccount: Bool?
    var currency: CurrencyDTO?
}
