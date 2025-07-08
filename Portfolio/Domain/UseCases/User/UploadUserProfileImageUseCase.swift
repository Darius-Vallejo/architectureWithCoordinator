//
//  UploadUserProfileImageUseCaseProtocol.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 12/12/24.
//

import UIKit

class UploadUserProfileImageUseCase: UploadUserProfileImageUseCaseProtocol {
    let repository: UserProfileRepositoryProtocol

    init(repository: UserProfileRepositoryProtocol = UserProfileRepository()) {
        self.repository = repository
    }

    func execute(image: UIImage) async throws -> UserProfileModel {
        return try await repository.uploadProfileImage(image: image).async()
    }
}
