//
//  UploadUserProfileImageUseCaseProtocol 2.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 12/12/24.
//

import UIKit

protocol UploadUserProfileImageUseCaseProtocol {
    func execute(image: UIImage) async throws -> UserProfileModel
}
