//
//  AttachmentRepositoryProtocol.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 13/01/25.
//

import Alamofire
import Combine
import Foundation

class AttachmentRepository: AttachmentRepositoryProtocol {
    private let networkManager: ServicesProcol

    init(networkManager: ServicesProcol = Services.shared) {
        self.networkManager = networkManager
    }

    /// Find all finds all expenses the expenses even if it doen't contain an attachemnt
    func fetchAttachments(assetId: Int,
                          findAllExpenses: Bool) -> AnyPublisher<[AttachmentDomainModel], NetworkError> {
        var endpoint: ExpenseEndpoints = .allExpenses(assetId: assetId)
        if !findAllExpenses {
            endpoint = .getJustAttachments(id: assetId)
        }

        return networkManager.fetch(
            endPoint: endpoint,
            type: [AttachmentDTO].self
        )
        .map { AttachmentDomainMapper().mapList(response: $0) }
        .eraseToAnyPublisher()
    }

    func saveAttachment(_ attachment: NewAttachmentModel) async throws(NetworkError) {
        let multipartData = MultipartFormData()
        multipartData.append("\(attachment.value)".data(using: .utf8)!, withName: "value")
        multipartData.append(attachment.type.rawValue.data(using: .utf8)!, withName: "type")
        multipartData.append("\(attachment.isCreatedAsAttachment)".data(using: .utf8)!, withName: "isCreatedAsAttachment")
        multipartData.append(attachment.name.data(using: .utf8)!, withName: "name")
        multipartData.append("\(attachment.assetId)".data(using: .utf8)!, withName: "assetId")

        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate]
        if let date = attachment.dateDomain {
            let formattedDate = dateFormatter.string(from: date)
            if let dateOfAttachment = formattedDate.data(using: .utf8) {
                multipartData.append(dateOfAttachment, withName: "date")
            }
        }

        if let pdfUrl = attachment.documents {
            multipartData.append(pdfUrl, withName: "documents", fileName: "document0.pdf", mimeType: "application/pdf")
        }

        do {
            let _ = try await networkManager.multipartRequest(
                endPoint: ExpenseEndpoints.saveExpenseWithAttachment,
                multipart: multipartData,
                type: NoContentDto.self
            ).async()
        } catch {
            throw makeNetworkError(from: error)
        }
    }

    func saveExpenese(_ expense: NewAttachmentModel) async throws(NetworkError) {
        do {
            var newExpense = expense
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions = [.withFullDate]
            if let date = expense.dateDomain {
                let formattedDate = dateFormatter.string(from: date)
                newExpense.date = formattedDate
                newExpense.dateDomain = nil
            }
            let result = try await networkManager.fetch(endPoint: ExpenseEndpoints.saveExpense(params: newExpense),
                                                        type: NoContentDto.self).async()
            print(result)
        } catch {
            throw makeNetworkError(from: error)
        }
    }

    private func makeNetworkError(from error: Error) -> NetworkError {
        if let networkError = error as? NetworkError {
            return networkError
        } else {
            return NetworkError.unknownError(error)
        }
    }

    func fetchAttachments(from date: Date, assetId: Int) -> AnyPublisher<[AttachmentDomainModel], NetworkError> {
        // Convert the date to a string (e.g. "2025-02-25")
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        let dateString = formatter.string(from: date) // e.g. "2025-02-25"

        let endpoint = ExpenseEndpoints.fromDate(dateString: dateString, assetId: assetId)

        return networkManager.fetch(endPoint: endpoint, type: [AttachmentDTO].self)
            .map { AttachmentDomainMapper().mapList(response: $0) }
            .eraseToAnyPublisher()
    }

    func fetchExpenseReport(assetId: Int, years: [Int]) -> AnyPublisher<[Expense], NetworkError> {
        let endpoint = ExpenseEndpoints.getExpenseReport(assetId: assetId, years: years)
        return networkManager.fetch(endPoint: endpoint, type: ReportDTO.self)
            .map { rawDict in
                // rawDict is [String: [String: Double]]
                // Convert to [Expense]
                var results: [Expense] = []
                for (yearStr, monthsDict) in rawDict {
                    guard let yearInt = Int(yearStr) else { continue }
                    for (monthStr, value) in monthsDict {
                        guard let monthInt = Int(monthStr) else { continue }
                        // Create an Expense domain object
                        let expense = Expense(
                            year: yearInt,
                            month: monthInt,
                            price: value,
                            // optional date construction
                            date: DateComponents(
                                calendar: .current,
                                year: yearInt,
                                month: monthInt,
                                day: 1
                            ).date ?? Date()
                        )
                        results.append(expense)
                    }
                }
                return results
            }
            .eraseToAnyPublisher()
    }

    func deleteExpense(id: Int) -> AnyPublisher<Void, NetworkError> {
        let endpoint = ExpenseEndpoints.deleteExpense(id: id)
        // We expect no JSON body in response, just a 204 or 200 on success
        return networkManager.fetch(endPoint: endpoint, type: NoContentDto.self)
            .map { _ in () } // transform NoContentDto -> Void
            .eraseToAnyPublisher()
    }

    /// Updates an existing expense/attachment by ID in multipart form.
    func updateAttachment(expenseId: Int, attachment: UpdateAttachmentModel) async throws(NetworkError) -> AttachmentDomainModel {
        let multipartData = MultipartFormData()

        // 1) Basic fields
        multipartData.append("\(attachment.value)".data(using: .utf8)!, withName: "value")
        multipartData.append(attachment.type.rawValue.data(using: .utf8)!, withName: "type")
        multipartData.append(attachment.name.data(using: .utf8)!, withName: "name")

        // 2) Date
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate]
        if let date = attachment.dateDomain {
            let formattedDate = dateFormatter.string(from: date)
            if let dateOfAttachment = formattedDate.data(using: .utf8) {
                multipartData.append(dateOfAttachment, withName: "date")
            }
        }

        // 3) Possibly update an attached file, if present
        if let pdfUrl = attachment.documents {
            multipartData.append(pdfUrl, withName: "documents", fileName: "document0.pdf", mimeType: "application/pdf")
        }

        // 4) Make the PUT request
        do {
            return try await networkManager.multipartRequest(
                endPoint: ExpenseEndpoints.updateExpenseWithAttachment(id: expenseId),
                multipart: multipartData,
                type: AttachmentDTO.self
            )
            .map { AttachmentDomainMapper().mapValue(response: $0) }
            .eraseToAnyPublisher()
            .async()
        } catch {
            throw makeNetworkError(from: error)
        }
    }

    /// Updates an existing expense/attachment by ID in multipart form.
    func updateExpense(expenseId: Int, attachment: UpdateAttachmentModel) async throws(NetworkError) -> AttachmentDomainModel {
        do {
            var newExpense = attachment
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions = [.withFullDate]
            if let date = attachment.dateDomain {
                let formattedDate = dateFormatter.string(from: date)
                newExpense.date = formattedDate
                newExpense.dateDomain = nil
            }
            let result = try await networkManager.fetch(endPoint: ExpenseEndpoints.updateExpense(id: expenseId,
                                                                                                 params: newExpense),
                                                        type: AttachmentDTO.self)
                .map { AttachmentDomainMapper().mapValue(response: $0) }
                .eraseToAnyPublisher()
                .async()
            return result
        } catch {
            throw makeNetworkError(from: error)
        }

    }


}
