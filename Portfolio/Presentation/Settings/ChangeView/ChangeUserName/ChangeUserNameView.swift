//
//  ChangeUserNameView.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 24/11/24.
//

import SwiftUI

struct ChangeUserNameView: View {
    @ObservedObject var viewModel: ChangeUserNameViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            VStack {
                CustomTextField(text: $viewModel.nickname, placeholder: String.localized(.changeUsername))
                Spacer()
                PrimaryButton(title: String.localized(.save)) {
                    viewModel.changeNickname()
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .addBackButton(andPrincipalTitle: String.localized(.changeUsername))
            .onReceive(viewModel.nickNameHasChanged) {
                dismiss()
            }

            if viewModel.isLoading {
                VStack {
                    Spacer()
                    ProgressView()
                        .tint(Color.blackPortfolio)
                        .scaleEffect(2)
                    Spacer()
                }
            }
        }
        .errorBanner(isShown: $viewModel.shouldShowError,
                     message: viewModel.errorMessage)
    }
}


#Preview {
    @Previewable @State var user: UserProfileModel?
    NavigationStack {
        ChangeUserNameView(viewModel: .init(userInfo: $user))
    }
}
