//
//  SaveSessionProtocol.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 22/11/24.
//


protocol SaveSessionProtocol {
    func execute(session: SessionModel, authSession: SessionAuthModel?) throws
}
