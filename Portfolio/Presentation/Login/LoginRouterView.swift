//
//  LoginView.swift
//  portfolio
//
//  Created by Dario Fernando Vallejo Posada on 13/11/24.
//

import SwiftUI


struct LoginRouterView: View {

    @StateObject var viewModel: LoginRouterViewModel
    private let coordinator: LoginCoordinatorProtocol

    init(viewModel: LoginRouterViewModel, coordinator: LoginCoordinatorProtocol) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }

    var body: some View {
        validatedBody()
            .environmentObject(viewModel)
    }

    func loadingBody() -> some View {
        VStack {
            Spacer()
            ProgressView()
                .tint(Color.blackPortfolio)
                .scaleEffect(2)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .ignoresSafeArea()
        .background(Color.yellowPortfolio)
        .onAppear {
           viewModel.viewDidAppear()
        }
    }

    @ViewBuilder
    func validatedBody() -> some View {
        if viewModel.isLoading {
            loadingBody()
        } else {
            LoginView(
                viewModel: coordinator.makeLoginViewModel(isLoggedIn: viewModel.isSavedUser),
                coordinator: coordinator
            )
        }
    }
}

#Preview {
    LoginCoordinatorFactory.create().makeLoginRouterView()
}
