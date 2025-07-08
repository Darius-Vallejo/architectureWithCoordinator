//
//  SessionRepository.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 22/11/24.
//


final class SessionRepository: SessionRepositoryProtocol {

    private typealias Constants = SessionRepositoryConstants

    static let shared = SessionRepository()
    private var authSession: SessionAuthModel?
    private var userSession: SessionModel?
    private init() {}

    func saveSession(session: SessionModel) throws {
        try KeychainHelper.save(session, account: Constants.key)
        setUserSession(session)
    }

    func getSession() throws -> SessionModel {
        guard let session = userSession else {
            setUserSession(try KeychainHelper.read(account: Constants.key))
            return userSession!
        }
        return session
    }

    func getAuthSession() throws -> SessionAuthModel {
        if authSession != nil { return authSession! }
        if let localSession = try? KeychainHelper.read(account: Constants.authKey) as SessionAuthModel {
            authSession = localSession
        } else {
            //This section exist to keep backward compatibility. To be removed in a later release
            authSession = try KeychainHelper.read(account: Constants.key) as SessionAuthModel
        }
        return authSession!
    }

    func saveAuthSession(session: SessionAuthModel) throws {
        try KeychainHelper.save(session, account: Constants.authKey)
        authSession = session
    }

    func deleteSession() throws {
        try KeychainHelper.delete(account: Constants.key)
        try KeychainHelper.delete(account: Constants.authKey)
        authSession = nil
        setUserSession(nil)
    }

    func deleteAllKeychainData() {
        KeychainHelper.reset()
    }

    private func setUserSession(_ session: SessionModel?) {
        userSession = session
    }
}
