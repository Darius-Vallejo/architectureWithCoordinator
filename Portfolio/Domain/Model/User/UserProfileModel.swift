//
//  UserProfileModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 2/12/24.
//


import Foundation

public class UserProfileModel: ObservableObject {
    var userId: String
    var firstName: String
    var lastName: String
    var email: String
    var nickname: String
    var description: String
    @Published var profilePicture: String?
    @Published var privateAccount: Bool
    @Published var currency: CurrencyModel

    init(userId: String,
         firstName: String,
         lastName: String,
         email: String,
         nickname: String,
         description: String,
         profilePicture: String,
         privateAccount: Bool,
         currency: CurrencyModel) {
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.nickname = nickname
        self.description = description
        self.privateAccount = privateAccount
        self.currency = currency
        self.profilePicture = profilePicture
    }
}
