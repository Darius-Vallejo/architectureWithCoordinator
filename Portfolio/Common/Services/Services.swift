//
//  Services.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 7/09/24.
//

import Foundation
import Alamofire
import Combine

class Services {

    static let shared = Services()

    enum HeaderConstants: String {
        case auth = "Authorization"
        case bearer = "Bearer"
        case content = "Content-Type"
        case application = "application/json"
    }

    private static let timeoutInSeconds: TimeInterval = 30
    private static let configuration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = timeoutInSeconds
        return configuration
    }()

    public lazy var session: Session = {
        return Session(configuration: Services.configuration,
                       serverTrustManager: ServerTrustManager(allHostsMustBeEvaluated: false, evaluators: [:]))
    }()

    private init() {}
}

class PDFServices {
    static let pdfCache = URLCache(
        memoryCapacity: 20 * 1024 * 1024,  // e.g., 20 MB in-memory
        diskCapacity: 100 * 1024 * 1024,   // e.g., 100 MB on disk
        diskPath: "pdfCache"
    )

    static let shared = PDFServices()

    private init() {}

    private static let configuration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.af.default
        configuration.urlCache = pdfCache
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return configuration
    }()

    /// A custom Alamofire `Session`
    let pdfSession = Session(configuration: configuration)
}

extension Services {
    func filterData<T>(_ output: DataResponsePublisher<T>.Output) throws -> Data {
        let defaultError = NetworkError.invalidResponse
        guard let httpResponse = output.response else {
            print("---> output \(output)")
            throw defaultError
        }

        switch output.result {
        case .success:
            guard let data = output.data else {
                if httpResponse.statusCode == ResponseStatusType.noContent.rawValue{
                    return try JSONEncoder().encode(NoContentDto())
                } else {
                    print("[Request] No data received")
                    throw defaultError
                }
            }

            return data
        case .failure(let afError):
            let response = output.response
            let statusCode = response?.statusCode ?? 0
            let urlDescription = httpResponse.url?.description ?? "Unknown"

            print("[Request] \(urlDescription) [\(statusCode)] ERROR: \(afError) \(response?.description ?? "")")

            throw NetworkError.networkError(afError)
        }
    }
}
