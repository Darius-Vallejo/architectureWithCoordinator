//
//  UserProfileCoordinator.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 13/11/24.
//

import SwiftUI
import Combine

// MARK: - UserProfileCoordinator Protocol
protocol UserProfileCoordinatorProtocol {
    func makeUserProfileView() -> UserProfileView
    func makeUserProfileViewModel() -> UserProfileViewModel
    func makeSettingsView(userProfile: Binding<UserProfileModel?>) -> SettingsView
    func makeChooseFromLibrarySettingsView(userInfo: Binding<UserProfileModel?>) -> ChooseFromLibrarySettingsView
    func makeTakePhotoSettingsView(userInfo: Binding<UserProfileModel?>) -> TakePhotoSettingsView
    func makeChangeUserNameView(userInfo: Binding<UserProfileModel?>) -> ChangeUserNameView
    func makeChangeDescriptionView(userInfo: Binding<UserProfileModel?>) -> ChangeDescriptionView
}

// MARK: - UserProfileCoordinator Implementation
class UserProfileCoordinator: UserProfileCoordinatorProtocol {
    
    // MARK: - Dependencies
    private let userProfileRepository: UserProfileRepositoryProtocol
    private let carAssetRepository: CarAssetRepositoryProtocol
    
    // MARK: - Use Cases
    private lazy var retrieveUserProfileUseCase: RetrieveUserProfileUseCaseProtocol = {
        RetrieveUserProfileUseCase(repository: userProfileRepository)
    }()
    
    private lazy var retrieveAssetsUseCase: FetchAssetsUseCaseProtocol = {
        FetchAssetsUseCase(repository: carAssetRepository)
    }()
    
    private lazy var updateUserNicknameUseCase: UpdateUserNicknameUseCaseProtocol = {
        UpdateUserNicknameUseCase(repository: userProfileRepository)
    }()
    
    private lazy var updateUserDescriptionUseCase: UpdateUserDescriptionUseCaseProtocol = {
        UpdateUserDescriptionUseCase(repository: userProfileRepository)
    }()
    
    private lazy var updateUserCurrencyUseCase: UpdateUserCurrencyUseCaseProtocol = {
        UpdateUserCurrencyUseCase(repository: userProfileRepository)
    }()
    
    private lazy var updateUserPrivacityUseCase: UpdateUserPrivacityUseCaseProtocol = {
        UpdateUserPrivacityUseCase(repository: userProfileRepository)
    }()
    
    private lazy var uploadUserProfileImageUseCase: UploadUserProfileImageUseCaseProtocol = {
        UploadUserProfileImageUseCase(repository: userProfileRepository)
    }()
    
    // MARK: - Initialization
    init(
        userProfileRepository: UserProfileRepositoryProtocol = UserProfileRepository(),
        carAssetRepository: CarAssetRepositoryProtocol = CarAssetRepository()
    ) {
        self.userProfileRepository = userProfileRepository
        self.carAssetRepository = carAssetRepository
    }
    
    // MARK: - View Creation Methods
    func makeUserProfileView() -> UserProfileView {
        let viewModel = makeUserProfileViewModel()
        return UserProfileView(viewModel: viewModel, coordinator: self)
    }
    
    func makeSettingsView(userProfile: Binding<UserProfileModel?>) -> SettingsView {
        return SettingsView(viewModel: .init(userProfile: userProfile))
    }
    
    func makeChooseFromLibrarySettingsView(userInfo: Binding<UserProfileModel?>) -> ChooseFromLibrarySettingsView {
        return ChooseFromLibrarySettingsView(viewModel: .init(userInfo: userInfo))
    }
    
    func makeTakePhotoSettingsView(userInfo: Binding<UserProfileModel?>) -> TakePhotoSettingsView {
        return TakePhotoSettingsView(viewModel: .init(userInfo: userInfo))
    }
    
    func makeChangeUserNameView(userInfo: Binding<UserProfileModel?>) -> ChangeUserNameView {
        return ChangeUserNameView(viewModel: .init(userInfo: userInfo))
    }
    
    func makeChangeDescriptionView(userInfo: Binding<UserProfileModel?>) -> ChangeDescriptionView {
        return ChangeDescriptionView(viewModel: .init(userInfo: userInfo))
    }
    
    // MARK: - ViewModel Creation Methods
    func makeUserProfileViewModel() -> UserProfileViewModel {
        return UserProfileViewModel(
            retrieveUserProfileUseCase: retrieveUserProfileUseCase,
            retrieveAssetsUseCase: retrieveAssetsUseCase
        )
    }
}

// MARK: - UserProfileCoordinator Factory
class UserProfileCoordinatorFactory {
    static func create() -> UserProfileCoordinatorProtocol {
        return UserProfileCoordinator()
    }
    
    static func createForTesting(
        userProfileRepository: UserProfileRepositoryProtocol,
        carAssetRepository: CarAssetRepositoryProtocol
    ) -> UserProfileCoordinatorProtocol {
        return UserProfileCoordinator(
            userProfileRepository: userProfileRepository,
            carAssetRepository: carAssetRepository
        )
    }
} 