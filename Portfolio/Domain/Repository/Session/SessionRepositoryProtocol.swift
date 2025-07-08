//
//  SessionRepositoryProtocol.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 22/11/24.
//


protocol SessionRepositoryProtocol {
    func saveSession(session: SessionModel) throws
    func getSession() throws -> SessionModel
    func saveAuthSession(session: SessionAuthModel) throws
    func getAuthSession() throws -> SessionAuthModel
    func deleteSession() throws
}
