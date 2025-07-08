//
//  LoginCoordinator.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 13/11/24.
//

import SwiftUI
import Combine

// MARK: - LoginCoordinator Protocol
protocol LoginCoordinatorProtocol {
    func makeLoginRouterView() -> LoginRouterView
    func makeLoginView(isLoggedIn: Bool) -> LoginView
    func makeLoginViewModel(isLoggedIn: Bool) -> LoginViewModel
    func makeLoginRouterViewModel() -> LoginRouterViewModel
    func makeUserProfileView() -> UserProfileView
}

// MARK: - LoginCoordinator Implementation
class LoginCoordinator: LoginCoordinatorProtocol {
    
    // MARK: - Dependencies
    private let sessionRepository: SessionRepositoryProtocol
    private let loginRepository: LoginRepositoryProtocol
    private let googleSignInRepository: LoginWithPresentingProtocol
    private let carAssetRepository: CarAssetRepositoryProtocol
    private let userProfileRepository: UserProfileRepositoryProtocol
    
    // MARK: - Child Coordinators
    private lazy var userProfileCoordinator: UserProfileCoordinatorProtocol = {
        UserProfileCoordinator(
            userProfileRepository: userProfileRepository,
            carAssetRepository: carAssetRepository
        )
    }()
    
    // MARK: - Use Cases
    private lazy var saveSessionUseCase: SaveSessionProtocol = {
        SaveSessionUseCase(sessionRepository)
    }()
    
    private lazy var retrieveSessionUseCase: RetriveSessionUseCaseProtocol = {
        RetriveSessionUseCase(sessionRepository)
    }()
    
    private lazy var googleLoginUseCase: LoginWithPresentationUseCaseProtocol = {
        LoginWithPresentationUseCase(repository: googleSignInRepository)
    }()
    
    private lazy var loginWithTokenUseCase: LoginWithTokenUseCaseProtocol = {
        LoginWithTokenUseCase(repository: loginRepository)
    }()
    
    private lazy var fetchAssetsUseCase: FetchAssetsUseCaseProtocol = {
        FetchAssetsUseCase(repository: carAssetRepository)
    }()
    
    // MARK: - Initialization
    init(
        sessionRepository: SessionRepositoryProtocol = SessionRepository.shared,
        loginRepository: LoginRepositoryProtocol = LoginRepository(),
        googleSignInRepository: LoginWithPresentingProtocol = GoogleSignInRepository(),
        carAssetRepository: CarAssetRepositoryProtocol = CarAssetRepository(),
        userProfileRepository: UserProfileRepositoryProtocol = UserProfileRepository()
    ) {
        self.sessionRepository = sessionRepository
        self.loginRepository = loginRepository
        self.googleSignInRepository = googleSignInRepository
        self.carAssetRepository = carAssetRepository
        self.userProfileRepository = userProfileRepository
    }
    
    // MARK: - View Creation Methods
    func makeLoginRouterView() -> LoginRouterView {
        let routerViewModel = makeLoginRouterViewModel()
        return LoginRouterView(viewModel: routerViewModel, coordinator: self)
    }
    
    func makeLoginView(isLoggedIn: Bool) -> LoginView {
        let loginViewModel = makeLoginViewModel(isLoggedIn: isLoggedIn)
        return LoginView(viewModel: loginViewModel, coordinator: self)
    }
    
    func makeUserProfileView() -> UserProfileView {
        // El LoginCoordinator delega la creación de UserProfileView al UserProfileCoordinator
        return userProfileCoordinator.makeUserProfileView()
    }
    
    // MARK: - ViewModel Creation Methods
    func makeLoginViewModel(isLoggedIn: Bool) -> LoginViewModel {
        return LoginViewModel(
            isLoggedIn: isLoggedIn,
            saveSessionUseCase: saveSessionUseCase,
            googleLogin: googleLoginUseCase,
            loginWithToken: loginWithTokenUseCase
        )
    }
    
    func makeLoginRouterViewModel() -> LoginRouterViewModel {
        return LoginRouterViewModel(
            retriveSessionUseCase: retrieveSessionUseCase,
            fetchAssetsUseCase: fetchAssetsUseCase
        )
    }
}

// MARK: - LoginCoordinator Factory
class LoginCoordinatorFactory {
    static func create() -> LoginCoordinatorProtocol {
        return LoginCoordinator()
    }
    
    static func createForTesting(
        sessionRepository: SessionRepositoryProtocol,
        loginRepository: LoginRepositoryProtocol,
        googleSignInRepository: LoginWithPresentingProtocol,
        carAssetRepository: CarAssetRepositoryProtocol,
        userProfileRepository: UserProfileRepositoryProtocol
    ) -> LoginCoordinatorProtocol {
        return LoginCoordinator(
            sessionRepository: sessionRepository,
            loginRepository: loginRepository,
            googleSignInRepository: googleSignInRepository,
            carAssetRepository: carAssetRepository,
            userProfileRepository: userProfileRepository
        )
    }
} 