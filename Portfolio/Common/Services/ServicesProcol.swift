//
//  ServicesProcol.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 8/09/24.
//

import Foundation
import Alamofire
import Combine

protocol ServicesProcol {
    func fetch<T: Decodable>(endPoint: EndpointBase, type _: T.Type) -> AnyPublisher<T, NetworkError>
    func multipartRequest<T: Decodable>(endPoint: EndpointBase, type _: T.Type) -> AnyPublisher<T, NetworkError>
    func multipartRequest<T: Decodable>(endPoint: EndpointBase, multipart: MultipartFormData , type _: T.Type) -> AnyPublisher<T, NetworkError> 
}

extension Services: ServicesProcol {
    func fetch<T: Decodable>(endPoint: EndpointBase, type _: T.Type) -> AnyPublisher<T, NetworkError> {
        var headers = HTTPHeaders(endPoint.headers)
        headers.add(name: "Authorization", value: getAccessToken())
        let method = HTTPMethod(rawValue: endPoint.method)

        return session.request(endPoint.urlString,
                               method: method,
                               parameters: endPoint.parameters,
                               encoding: endPoint.encoding,
                               headers: headers,
                               interceptor: getInterceptor(endpoint: endPoint, accessToken: getAccessToken())
        )
        .validate(statusCode: 200..<400)
        .publishDecodable(type: T.self)
        .tryMap { output in
            try self.filterData(output)
        }
        .decode(type: T.self, decoder: JSONDecoder())
        .handleEvents(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                print("[Request] \(endPoint.urlString) Error: \(error.localizedDescription)")
            case .finished:
                print("[Request] \(endPoint.urlString) - SUCCESS")
            }
        })
        .mapError { error in
            print("[Request] \(endPoint.urlString) Error mapping the result")
            if let errorDetails = error as? AFError {
                return NetworkError.networkError(errorDetails)
            }
            return NetworkError.unknownError(error)
        }
        .eraseToAnyPublisher()
    }

    func multipartRequest<T: Decodable>(endPoint: EndpointBase, type _: T.Type) -> AnyPublisher<T, NetworkError> {
        var headers = HTTPHeaders(endPoint.headers)
        headers.add(name: "Authorization", value: getAccessToken())
        return session.upload(multipartFormData: { multipartFormData in
            for (key, value) in endPoint.parameters {
                if let value_ = value as? String {
                    multipartFormData.append(value_.data(using: String.Encoding.utf8)!, withName: key, mimeType: "application/json")
                }
            }
            print("[Request] \(multipartFormData)")
        },
                              to: endPoint.urlString,
                              headers: headers,
                              interceptor: getInterceptor(endpoint: endPoint, accessToken: getAccessToken()))
        .validate(statusCode: 200..<400)
        .publishDecodable(type: T.self)
        .tryMap { output in
            try self.filterData(output)
        }
        .decode(type: T.self, decoder: JSONDecoder())
        .handleEvents(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                print("[Request] \(endPoint.urlString) Error: \(error.localizedDescription)")
            case .finished:
                print("[Request] \(endPoint.urlString) - SUCCESS")
            }
        })
        .mapError { error in
            print("[Request] \(endPoint.urlString) Error mapping the result")
            if let errorDetails = error as? AFError {
                return NetworkError.networkError(errorDetails)
            }
            return NetworkError.unknownError(error)
        }
        .eraseToAnyPublisher()
    }

    func multipartRequest<T: Decodable>(endPoint: EndpointBase, multipart: MultipartFormData , type _: T.Type) -> AnyPublisher<T, NetworkError> {
        var headers = HTTPHeaders(endPoint.headers)
        headers.add(name: "Authorization", value: getAccessToken())
        let method = HTTPMethod(rawValue: endPoint.method)

        return session.upload(multipartFormData: multipart,
                              to: endPoint.urlString,
                              method: method,
                              headers: headers,
                              interceptor: getInterceptor(endpoint: endPoint, accessToken: getAccessToken()))
        .validate(statusCode: 200..<400)
        .publishDecodable(type: T.self)
        .tryMap { output in
            try self.filterData(output)
        }
        .decode(type: T.self, decoder: JSONDecoder())
        .handleEvents(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                print("[Request] \(endPoint.urlString) Error: \(error.localizedDescription)")
            case .finished:
                print("[Request] \(endPoint.urlString) - SUCCESS")
            }
        })
        .mapError { error in
            print("[Request] \(endPoint.urlString) Error mapping the result")
            if let errorDetails = error as? AFError {
                return NetworkError.networkError(errorDetails)
            }
            return NetworkError.unknownError(error)
        }
        .eraseToAnyPublisher()
    }
}
