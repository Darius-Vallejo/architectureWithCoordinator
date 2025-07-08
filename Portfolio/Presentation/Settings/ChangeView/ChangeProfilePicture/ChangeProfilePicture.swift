//
//  ChangeProfilePicture.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 25/11/24.
//

import SwiftUI

struct ChangeProfilePictureView: View {

    @EnvironmentObject var navigatioAdapter: NavigationAdapterForSettings
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Button {
                dismiss()
                navigatioAdapter.path.append(UserProfileViewModel.NavigationDestination.chooseFromLibrary)
            } label: {
                SettingRow(iconName: "settingsProfileIcon",
                            iconColor: .yellowPortfolio,
                            title: String.localized(.chooseFromLibrary))
            }
            Button {
                dismiss()
                navigatioAdapter.path.append(UserProfileViewModel.NavigationDestination.takeAPhoto)
            } label: {
                SettingRow(iconName: "settingsCameraIcon",
                            iconColor: .yellowPortfolio,
                           title: String.localized(.takePhoto))
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .addBackButton(andPrincipalTitle: String.localized(.changeUsername))
    }
}


#Preview {
    NavigationStack {
        ChangeProfilePictureView()
    }
}



