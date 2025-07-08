//
//  SettingsView.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 23/11/24.
//

import SwiftUI
import UIKit

struct SettingsView: View {

    @StateObject var viewModel: SettingsViewModel
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var loginViewModel: LoginRouterViewModel
    @EnvironmentObject var navigatioAdapter: NavigationAdapterForSettings
    @State private var showWebView: Bool = false

    var body: some View {
        VStack(spacing: 0) {

            Button {
                navigatioAdapter.path.append(UserProfileViewModel.NavigationDestination.userName)
            } label: {
                SettingRow(iconName: "settingsUserIcon",
                            iconColor: .yellowPortfolio,
                            title: String.localized(.changeUsername))
            }
            Divider()

            Button {
                viewModel.isOpenPictureSheet.toggle()
            } label: {
                SettingRow(iconName: "settingsProfileIcon",
                            iconColor: .yellowPortfolio,
                            title: String.localized(.changeProfilePicture))
            }
            Divider()

            Button {
                navigatioAdapter.path.append(UserProfileViewModel.NavigationDestination.description)
            } label: {
                SettingRow(iconName: "settingsDescriptionIcon",
                            iconColor: .yellowPortfolio,
                            title: String.localized(.changeDescription))
            }
            Divider()

            Button {
                viewModel.isOpenCurrencySheet.toggle()
            } label: {
                SettingRow(iconName: "settingsCurrencyIcon",
                            iconColor: .yellowPortfolio,
                            title: String.localized(.changeCurrency))
            }
            Divider()

            privacyToggleRow(iconName: "settingsAccountIcon",
                             iconColor: .yellowPortfolio,
                             title: String.localized(.makeYourAccountPrivate),
                             isOn: Binding<Bool>(
                                get:{
                                    return viewModel.isPrivate
                                },
                                set:{ newValue in
                                    viewModel.changePrivacity(isPrivate: newValue)
                                }
                             ))
            Divider()

            Button {
                viewModel.logout()
                withAnimation {
                    loginViewModel.logout()
                }
            } label: {
                SettingRow(iconName: "sttingsLogoutIcon",
                           iconColor: .danger200,
                           iconForegroundColor: .danger700,
                           opacity: 1,
                           title: String.localized(.logout),
                           titleColor: .danger700,
                           showTrailingImage: false)
            }
            Divider()

            let viewPP = "View Privacy Policy"
            Button(viewPP) {
                showWebView = true
            }
            .foregroundStyle(Color.blue)
            .padding(.top, 38)


            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .fullScreenCover(isPresented: $showWebView) {
            WebViewWithCloseButton(url: URL(string: "https://portfolio.test.likemetric.com/terms")!)
        }
        .addBackButton(andPrincipalTitle: String.localized(.settingsTitle))
        .bottomSheet(showSheet: $viewModel.isOpenPictureSheet,
                     view: ChangeProfilePictureView())
        .bottomSheet(showSheet: $viewModel.isOpenCurrencySheet,
                     view: ChangeCurrencyView(viewModel: .init(userInfo: Binding<UserProfileModel?>(
                        get: {
                            return viewModel.userProfile
                        },
                        set: { user in
                            viewModel.userProfile?.currency = user?.currency ?? .usd
                        }
                     ))))
        .errorBanner(isShown: $viewModel.shouldShowError,
                     message: viewModel.errorMessage)
    }

    private func privacyToggleRow(iconName: String,
                                  iconColor: Color,
                                  title: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Circle()
                .fill(iconColor.opacity(0.2))
                .frame(width: 36, height: 36)
                .overlay(
                    Image(iconName)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .foregroundColor(.blackPortfolio)
                        .frame(width: 16, height: 16)
                )

            Text(title)
                .font(Font.interDisplayMedium14)
                .foregroundColor(.blackPortfolio)
                .padding(.vertical, 13)

            Spacer()

            Toggle(String.empty, isOn: isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: Color.yellowPortfolio))
        }
        .padding(.horizontal, 8)
        .frame(height: 58)
    }
}


#Preview {
    @Previewable @State var userProfile: UserProfileModel?
    NavigationStack {
        SettingsView(viewModel: .init(userProfile: $userProfile))
    }
}

