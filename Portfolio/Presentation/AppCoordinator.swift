//
//  AppCoordinator.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 13/11/24.
//

import SwiftUI
import Combine

// MARK: - AppCoordinator Protocol
protocol AppCoordinatorProtocol {
    func makeContentView() -> ContentView
    func makeLoginFlow() -> LoginRouterView
    func makeUserProfileFlow() -> UserProfileView
}

// MARK: - AppCoordinator Implementation
class AppCoordinator: AppCoordinatorProtocol {
    
    // MARK: - Dependencies
    private let sessionRepository: SessionRepositoryProtocol
    private let loginRepository: LoginRepositoryProtocol
    private let googleSignInRepository: LoginWithPresentingProtocol
    private let carAssetRepository: CarAssetRepositoryProtocol
    private let userProfileRepository: UserProfileRepositoryProtocol
    
    // MARK: - Child Coordinators
    private lazy var loginCoordinator: LoginCoordinatorProtocol = {
        LoginCoordinator(
            sessionRepository: sessionRepository,
            loginRepository: loginRepository,
            googleSignInRepository: googleSignInRepository,
            carAssetRepository: carAssetRepository,
            userProfileRepository: userProfileRepository
        )
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
    func makeContentView() -> ContentView {
        return ContentView(coordinator: self)
    }
    
    func makeLoginFlow() -> LoginRouterView {
        return loginCoordinator.makeLoginRouterView()
    }
    
    func makeUserProfileFlow() -> UserProfileView {
        return loginCoordinator.makeUserProfileView()
    }
}

// MARK: - AppCoordinator Factory
class AppCoordinatorFactory {
    static func create() -> AppCoordinatorProtocol {
        return AppCoordinator()
    }
    
    static func createForTesting(
        sessionRepository: SessionRepositoryProtocol,
        loginRepository: LoginRepositoryProtocol,
        googleSignInRepository: LoginWithPresentingProtocol,
        carAssetRepository: CarAssetRepositoryProtocol,
        userProfileRepository: UserProfileRepositoryProtocol
    ) -> AppCoordinatorProtocol {
        return AppCoordinator(
            sessionRepository: sessionRepository,
            loginRepository: loginRepository,
            googleSignInRepository: googleSignInRepository,
            carAssetRepository: carAssetRepository,
            userProfileRepository: userProfileRepository
        )
    }
} 