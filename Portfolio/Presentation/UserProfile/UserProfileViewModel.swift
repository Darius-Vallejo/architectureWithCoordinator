//
//  UserProfileViewModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 23/11/24.
//


import SwiftUI

class UserProfileViewModel: ObservableObject {
    @Published var isShowingNewAssetMenu = false
    @Published var selectedImage: UIImage? = nil
    @Published var buttonPosition: CGPoint = .zero
    @Published var userDescription: String = ""
    @Published var userName: String?
    @Published var session: SessionModel
    @Published var nickName: String
    @Published var fullName: String
    @Published var userProfile: UserProfileModel?
    @Published var isLoading: Bool = false
    @Published var isProfileImageExpanded: Bool = false
    @Published var assetList: [AssetDomainModel] = []
    var image: Image? = nil

    private let retrieveUserProfileUseCase: RetrieveUserProfileUseCaseProtocol
    private let retrieveAssetsUseCase: FetchAssetsUseCaseProtocol

    init(
        isShowingNewAssetMenu: Bool = false,
        selectedImage: UIImage? = nil,
        retrieveUserProfileUseCase: RetrieveUserProfileUseCaseProtocol,
        retrieveAssetsUseCase: FetchAssetsUseCaseProtocol
    ) {
        self.isShowingNewAssetMenu = isShowingNewAssetMenu
        self.selectedImage = selectedImage
        let session = CurrentSessionHelper.shared.session ?? .init(token: "")
        self.session = session
        self.nickName = "@\(session.firstName?.lowercased() ?? .empty)\(session.lastName?.capitalized ?? .empty)"
        self.fullName = "\(session.firstName ?? .empty) \(session.lastName ?? .empty)"
        self.retrieveUserProfileUseCase = retrieveUserProfileUseCase
        self.retrieveAssetsUseCase = retrieveAssetsUseCase
    }

    func fetchUserProfile() {
        isLoading = true
        Task {
            do {
                let userProfile = try await retrieveUserProfileUseCase.execute()
                await MainActor.run {
                    self.userProfile = userProfile
                    userName = userProfile.firstName
                    userDescription = userProfile.description
                    fullName = "\(userProfile.firstName) \(userProfile.lastName)"
                    nickName = userProfile.nickname
                    isLoading = false
                    CurrentSessionHelper.shared.user = userProfile
                }
            } catch {
                print("Failed to retrieve user profile: \(error)")
                await MainActor.run {
                    isLoading = false
                }
            }
        }
    }

    func fetchAssets() {
        isLoading = true
        Task {
            do {
                let assets = try await retrieveAssetsUseCase.execute()
                await MainActor.run {
                    assetList = assets
                    isLoading = false
                }
            } catch {
                print("Failed to retrieve assets: \(error)")
                await MainActor.run {
                    isLoading = false
                }
            }
        }
    }

    func didSaveNewAsset(type: AssetType) {
        Task {
            try await Task.sleep(nanoseconds: 1_000_000_000)

            await MainActor.run {
                fetchAssets()
            }
        }
    }

    func getIconFromType(type: AssetType) -> String {
        switch type {
        case .house: return "profileHouseIcon"
        case .car: return "profileCarIcon"
        case .RV: return "profileRVIcon"
        case .aircraft: return "profileAircraftIcon"
        case .boat: return "profileBoatIcon"
        case .lot: return "profileLotIcon"
        }
    }

}


/// Navigation
extension UserProfileViewModel {
    enum NavigationDestination: Hashable {
        case settings
        case takeAPhoto
        case chooseFromLibrary
        case userName
        case description
    }
}

