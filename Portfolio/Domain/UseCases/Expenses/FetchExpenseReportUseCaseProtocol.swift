//
//  FetchExpenseReportUseCaseProtocol.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 29/01/25.
//

import Combine

protocol FetchExpenseReportUseCaseProtocol {
    func execute(assetId: Int, years: [Int]) -> AnyPublisher<[Expense], NetworkError>
}

class FetchExpenseReportUseCase: FetchExpenseReportUseCaseProtocol {
    private let repository: AttachmentRepositoryProtocol

    init(repository: AttachmentRepositoryProtocol) {
        self.repository = repository
    }

    func execute(assetId: Int, years: [Int]) -> AnyPublisher<[Expense], NetworkError> {
        repository.fetchExpenseReport(assetId: assetId, years: years)
    }
}
