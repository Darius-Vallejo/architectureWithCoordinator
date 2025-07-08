//
//  UserInfoDTO.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 2/12/24.
//

struct UserInfoDTO: Codable {
    var userId: String?
    var givenName: String?
    var familyName: String?
    var email: String?
    var profilePicture: String?
    var settings: SettingsDTO?
    func toDomain() -> UserProfileModel {
        UserInfoDomainMapper().mapValue(response: self)
    }
}

