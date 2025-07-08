//
//  ChangeDescriptionView.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 25/11/24.
//


import SwiftUI

struct ChangeDescriptionView: View {

    @ObservedObject var viewModel: ChangeDescriptionViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            CustomTextField(text: $viewModel.description,
                            placeholder: String.localized(.changeDescription),
                            axis: .vertical)
                .lineLimit(2...7)
            Spacer()
            PrimaryButton(title: String.localized(.save)) {
                viewModel.changeDescription()
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .addBackButton(andPrincipalTitle: String.localized(.changeDescription))
        .onReceive(viewModel.descriptionHasChanged) {
            dismiss()
        }
        .errorBanner(isShown: $viewModel.shouldShowError,
                     message: viewModel.errorMessage)
    }
}


#Preview {
    @Previewable @State var user: UserProfileModel?
    NavigationStack {
        ChangeDescriptionView(viewModel: .init(userInfo: $user))
    }
}
