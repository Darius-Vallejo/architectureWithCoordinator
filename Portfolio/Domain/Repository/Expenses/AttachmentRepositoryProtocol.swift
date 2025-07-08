//
//  AttachmentRepositoryProtocol.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 13/01/25.
//

import Combine
import Foundation

protocol AttachmentRepositoryProtocol {
    func saveAttachment(_ attachment: NewAttachmentModel) async throws(NetworkError)
    func saveExpenese(_ expense: NewAttachmentModel) async throws(NetworkError)
    func updateAttachment(expenseId: Int, attachment: UpdateAttachmentModel) async throws(NetworkError) -> AttachmentDomainModel
    func updateExpense(expenseId: Int, attachment: UpdateAttachmentModel) async throws(NetworkError) -> AttachmentDomainModel
    func fetchAttachments(assetId: Int,
                          findAllExpenses: Bool) -> AnyPublisher<[AttachmentDomainModel], NetworkError>
    func fetchAttachments(from date: Date, assetId: Int) -> AnyPublisher<[AttachmentDomainModel], NetworkError>
    func fetchExpenseReport(assetId: Int, years: [Int]) -> AnyPublisher<[Expense], NetworkError>
    func deleteExpense(id: Int) -> AnyPublisher<Void, NetworkError>
}
