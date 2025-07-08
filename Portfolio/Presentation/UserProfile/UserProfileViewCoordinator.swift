//
//  UserProfileViewCoordinator.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 4/12/24.
//

import SwiftUI

/// UserProfileCoordinator
extension UserProfileView {
    @ViewBuilder
    func view(for destination: UserProfileViewModel.NavigationDestination) -> some View {
        switch destination {
        case .settings:
            coordinator.makeSettingsView(userProfile: $viewModel.userProfile)
                .onDisappear(perform: viewModel.fetchUserProfile)
        case .chooseFromLibrary: 
            coordinator.makeChooseFromLibrarySettingsView(userInfo: $viewModel.userProfile)
        case .takeAPhoto: 
            coordinator.makeTakePhotoSettingsView(userInfo: $viewModel.userProfile)
        case .userName:
            coordinator.makeChangeUserNameView(userInfo: $viewModel.userProfile)
        case .description:
            coordinator.makeChangeDescriptionView(userInfo: $viewModel.userProfile)
        }
    }
}
