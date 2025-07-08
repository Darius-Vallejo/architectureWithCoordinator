//
//  NewAssetModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 30/11/24.
//

import Foundation

struct NewAssetModel: Identifiable {
    var id = UUID()
    var type: AssetType
}
