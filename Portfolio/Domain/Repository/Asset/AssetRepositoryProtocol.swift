//
//  AssetRepositoryProtocol.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 20/12/24.
//

import Combine

protocol AssetRepositoryProtocol {
    func saveModel(with model: AssetDomainModel) async throws(NetworkError)
}
