//
//  LoginView.swift
//  portfolio
//
//  Created by Dario Fernando Vallejo Posada on 13/11/24.
//

import SwiftUI

struct LoginView: View {
    private typealias Dimensions = LoginViewConstants.Dimensions
    private typealias Strings = LoginViewConstants.Strings
    private typealias Colors = LoginViewConstants.Colors
    private typealias Assets = LoginViewConstants.Assets

    @ObservedObject var viewModel: LoginViewModel
    @State private var showWebView: Bool = false
    private let coordinator: LoginCoordinatorProtocol
    
    init(viewModel: LoginViewModel, coordinator: LoginCoordinatorProtocol) {
        self.viewModel = viewModel
        self.coordinator = coordinator
    }

    var body: some View {
        VStack {
            ZStack {
                VStack(spacing: Dimensions.mainVerticalSpacing) {
                    Image(Assets.main)
                    VStack(spacing: Dimensions.titlesSpacing) {
                        Text(Strings.welcomeBack)
                            .foregroundColor(Colors.mainBlack)
                            .font(.newBlackTypefaceSemiBold32)
                        Text(Strings.welcomeBackDetail)
                            .foregroundColor(Colors.mainBlack)
                            .font(.newBlackTypefaceLight16)
                    }
                    .padding(.bottom, Dimensions.bottomPaddingForTitles)

                    VStack(spacing: Dimensions.bottonSpacings) {
                        Button {
                            if !viewModel.isLoading {
                                viewModel.signInWithGoogle(getRoot: getRootViewController)
                            }
                        } label: {
                            HStack {
                                Image(Assets.google)
                                Text(Strings.gmailLogin)
                                    .font(.molarumSemibold16)
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(width: Dimensions.buttonWidth, height: Dimensions.buttonHeight)
                        .background(
                            Colors.mainBlack
                                .cornerRadius(Dimensions.cornerRadius)
                        )
                        let viewPP = "View Privacy Policy"
                        Button(viewPP) {
                            showWebView = true
                        }
                        .foregroundStyle(Color.blue)
                        .padding(.top, 20)
                    }
                }
                if viewModel.isLoading {
                    VStack {
                        Spacer()
                        ProgressView()
                            .tint(Color.blackPortfolio)
                            .padding(.bottom, Dimensions.bottomPaddingForLoading)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(
            Colors.main
                .ignoresSafeArea()
        )
        .fullScreenCover(isPresented: $viewModel.isLoggedIn) {
            coordinator.makeUserProfileView()
        }
        .fullScreenCover(isPresented: $showWebView) {
            WebViewWithCloseButton(url: URL(string: "terms")!)
        }
        .banner(isShown: $viewModel.errorService,
                type: .error,
                message: "There is an error",
                hasAction: false,
                actionClosure: {},
                closeClosure: {}
        )
    }

    func getRootViewController() -> UIViewController {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }),
           let rootViewController = window.rootViewController {
            return rootViewController
        }
        return UIViewController()
    }
}

#Preview {
    LoginView(
        viewModel: .init(),
        coordinator: LoginCoordinatorFactory.create()
    )
}
