//
//  LoginDomainMapper.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 2/12/24.
//


struct UserInfoDomainMapper: DomainMapper {
    func mapValue(response: UserInfoDTO) -> UserProfileModel {
        let settings = response.settings

        return UserProfileModel(
            userId: response.userId ?? "",
            firstName: response.givenName ?? "",
            lastName: response.familyName ?? "",
            email: response.email ?? "",
            nickname: settings?.nickname ?? "",
            description: settings?.description ?? "",
            profilePicture: response.profilePicture ?? "",
            privateAccount: settings?.privateAccount ?? true,
            currency: CurrencyModel(rawValue: settings?.currency?.rawValue ?? "USD") ?? .usd
        )
    }
}
