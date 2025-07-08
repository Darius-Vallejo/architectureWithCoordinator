//
//  CurrentSessionHelper.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 23/11/24.
//

final class CurrentSessionHelper {
    static let shared = CurrentSessionHelper()
    public var session: SessionModel?
    public var user: UserProfileModel?

    private init() {}
}
