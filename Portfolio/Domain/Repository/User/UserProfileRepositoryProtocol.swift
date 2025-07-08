//
//  UserProfileRepositoryProtocol.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 2/12/24.
//

import Combine
import UIKit

protocol UserProfileRepositoryProtocol {
    func userInfo() -> AnyPublisher<UserProfileModel, NetworkError>
    func updateUserNickname(nickname: String) -> AnyPublisher<UserProfileModel, NetworkError>
    func updateUserDescription(description: String) -> AnyPublisher<UserProfileModel, NetworkError>
    func updateUserCurrency(currency: String) -> AnyPublisher<UserProfileModel, NetworkError>
    func updateUserPrivacity(privacity: Bool) -> AnyPublisher<UserProfileModel, NetworkError>
    func uploadProfileImage(image: UIImage) -> AnyPublisher<UserProfileModel, NetworkError>
}
