//
//  CarAssetMapper.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 21/12/24.
//

struct CarBrandMapper: DomainMapper {
    
    func mapValue(response: CarBrandDTO) -> CarBrandDetail {
        CarBrandDetail(id: String(response.id), name: response.name)
    }
    
}

struct CarModelMapper: DomainMapper {
    
    func mapValue(response: CarModelDTO) -> CarModelDetail {
        CarModelDetail(id: response.id, name: response.name)
    }
    
}
