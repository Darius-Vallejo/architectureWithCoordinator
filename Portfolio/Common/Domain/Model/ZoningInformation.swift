//
//  ZoningInformation.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 30/12/24.
//

public enum ZoningInformation: String, CaseIterable, Codable {
    case residential
    case commercial

    var title: String {
        switch self {
        case .commercial: String.localized(.commercial)
        case .residential: String.localized(.residential)
        }
    }
}
