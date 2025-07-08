//
//  CarAssetDTO.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 21/12/24.
//

struct CarBrandsDTO: Decodable {
    let brands: [CarBrandDTO]
}

struct CarBrandDTO: Decodable {
    let id: Int
    let name: String
}

struct CarModelsDTO: Decodable {
    let models: [CarModelDTO]
}

struct CarModelDTO: Decodable {
    let id: Int
    let name: String
    let makeId: Int
}
