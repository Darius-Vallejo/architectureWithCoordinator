//
//  ExpenseEndpoints.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 13/01/25.
//

import Alamofire

enum ExpenseEndpoints: EndpointBase {
    case saveExpenseWithAttachment
    case saveExpense(params: NewAttachmentModel)
    case getJustAttachments(id: Int)
    case allExpenses(assetId: Int)
    case fromDate(dateString: String, assetId: Int)
    case getExpenseReport(assetId: Int, years: [Int])
    case deleteExpense(id: Int)
    case updateExpenseWithAttachment(id: Int)
    case updateExpense(id: Int, params: UpdateAttachmentModel)

    private var baseUrl: String {
        Config.shared.baseUrl + "expenses/"
    }

    private var relativeURL: String {
        switch self {
        case .saveExpenseWithAttachment:
            return "with-attachment"
        case .getJustAttachments(let assetId):
            return "just-attachments?assetId=\(assetId)"
        case .allExpenses(let assetId):
            return "all?assetId=\(assetId)"
        case .saveExpense:
            return ""
        case .fromDate(let dateString, let assetId):
            return "from-date/\(dateString)?assetId=\(assetId)"
        case .getExpenseReport(let assetId, let years):
            let joined = years.map(String.init).joined(separator: ",")
            return "report?assetId=\(assetId)&years=\(joined)"
        case .deleteExpense(let expenseId):
            return "\(expenseId)"
        case .updateExpenseWithAttachment(let id):
            return "with-attachment/\(id)"
        case .updateExpense(id: let id, params: _):
            return "without-attachment/\(id)"
        }
    }

    var urlString: String {
        baseUrl + relativeURL
    }

    var method: String {
        switch self {
        case .deleteExpense:
            return EndpointMethods.delete.rawValue
        case .saveExpenseWithAttachment, .saveExpense:
            return EndpointMethods.post.rawValue
        case .updateExpenseWithAttachment, .updateExpense:
            return EndpointMethods.put.rawValue
        case .getJustAttachments, .allExpenses, .fromDate, .getExpenseReport:
            return EndpointMethods.get.rawValue
        }
    }

    var parameters: [String : Any] {
        switch self {
        case .saveExpense(let params):
            return params.dictionary() ?? [:]
        case .updateExpense(id: _, params: let params):
            return params.dictionary() ?? [:]
        default:
            return [:]
        }
    }

    var headers: [String : String] {
        switch self {
        case .saveExpenseWithAttachment, .updateExpenseWithAttachment:
            return ["Content-Type": "multipart/form-data"]
        default:
            return [:]
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .updateExpenseWithAttachment,
            .updateExpense,
             .saveExpenseWithAttachment,
             .saveExpense:
            return JSONEncoding.default
        case .deleteExpense, .fromDate, .getJustAttachments, .allExpenses, .getExpenseReport:
            return URLEncoding.default
        }
    }
}
