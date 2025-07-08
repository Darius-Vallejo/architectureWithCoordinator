//
//  ResponseStatusType.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 22/11/24.
//


enum ResponseStatusType: Int {
    case unknown = 0
    case success = 200
    case noContent = 204
    case invalidRequest = 400
    case unauthorized = 401
    case accountBlocked = 403
    case notFound = 404
    case conflict = 409
    case invalidData = 422
    case locked = 423
    case tooManyRequests = 429
    case internalServer = 500
    case serviceUnavailable = 503
}