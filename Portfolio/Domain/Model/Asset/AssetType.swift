//
//  AssetType.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 28/11/24.
//

public enum AssetType: String, CaseIterable {
    case car
    case RV
    case house
    case aircraft
    case boat
    case lot

    var navigationTitle: String {
        switch self {
        case .car: String.localized(.addNewCar)
        case .RV:  String.localized(.addNewRV)
        case .house:  String.localized(.addNewHouse)
        case .aircraft:  String.localized(.addNewAircraft)
        case .boat:  String.localized(.addNewBoat)
        case .lot:  String.localized(.addNewLot)
        }
    }

    var text: String {
        switch self {
        case .car: String.localized(.car)
        case .RV:  String.localized(.rv)
        case .house:  String.localized(.house)
        case .aircraft:  String.localized(.aircraft)
        case .boat:  String.localized(.boat)
        case .lot:  String.localized(.lot)
        }
    }
}
