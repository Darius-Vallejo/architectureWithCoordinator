//
//  TagForMarket.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 17/12/24.
//

public enum TagForMarket: String, CaseIterable {
    case rent
    case sell
    case offMarket

    var title: String {
        switch self {
        case .rent: String.localized(.rent)
        case .sell: String.localized(.sell)
        case .offMarket: String.localized(.offMarket)
        }
    }
}
