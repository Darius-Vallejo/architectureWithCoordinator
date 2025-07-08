//
//  UserProfileRepository.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 2/12/24.
//

import Combine
import UIKit
import Alamofire

class UserProfileRepository: UserProfileRepositoryProtocol {
    var services: ServicesProcol
    init(services: ServicesProcol = Services.shared) {
        self.services = services
    }

    func userInfo() -> AnyPublisher<UserProfileModel, NetworkError> {
        services
            .fetch(endPoint: UserEndpoint.userInfo, type: UserInfoDTO.self)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }

    func updateUserNickname(nickname: String) -> AnyPublisher<UserProfileModel, NetworkError> {
        let params = UpdateUserNicknameDTO(nickname: nickname)
        return services
            .fetch(endPoint: UserEndpoint.updateNickname(params: params), type: UserInfoDTO.self)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }

    func updateUserDescription(description: String) -> AnyPublisher<UserProfileModel, NetworkError> {
        let params = UpdateUserDescriptionDTO(description: description)
        return services
            .fetch(endPoint: UserEndpoint.updateDescription(params: params), type: UserInfoDTO.self)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }

    func updateUserCurrency(currency: String) -> AnyPublisher<UserProfileModel, NetworkError> {
        let params = UpdateUserCurrencyDTO(currency: currency)
        return services
            .fetch(endPoint: UserEndpoint.updateCurrency(params: params), type: UserInfoDTO.self)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }

    func updateUserPrivacity(privacity: Bool) -> AnyPublisher<UserProfileModel, NetworkError> {
        let params = UpdateUserPrivacityDTO(privateAccount: privacity)
        return services
            .fetch(endPoint: UserEndpoint.updatePrivacity(params: params), type: UserInfoDTO.self)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }

    func uploadProfileImage(image: UIImage) -> AnyPublisher<UserProfileModel, NetworkError> {
        guard let imageData = image.compress() else {
            return Fail(error: NetworkError.invalidData).eraseToAnyPublisher()
        }


        let multipartData = MultipartFormData()
        multipartData.append(imageData, withName: "image", fileName: "profile.jpg", mimeType: "image/jpeg")

        return services.multipartRequest(
            endPoint: UserEndpoint.uploadProfileImage(
                params: .init(image: imageData)
            ),
            multipart: multipartData,
            type: UserInfoDTO.self
        )
        .map { $0.toDomain() }
        .eraseToAnyPublisher()
    }

}
