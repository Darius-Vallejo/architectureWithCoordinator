//
//  ChangeCurrencyView.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 25/11/24.
//


import SwiftUI

struct ChangeCurrencyView: View {

    @ObservedObject var viewModel: ChangeCurrencyViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            ForEach(CurrencyModel.allCases, id: \.rawValue) { currency in
                HStack {
                    Group {
                        if viewModel.checkIfCurrencyIsSelected(currency: currency) {
                            Image("createAssetCheckIcon")
                        } else {
                            Circle()
                                .stroke(Color.yellowPortfolio, lineWidth: 2)
                                .shadow(radius: 0.5)
                        }
                    }
                    .frame(width: 20, height: 20)
                    .padding(4)
                    Text(currency.rawValue)
                        .font(.interDisplayMedium14)
                        .foregroundStyle(Color.blackPortfolio)
                    Spacer()
                }
                .onTapGesture {
                    viewModel.changeCurrency(currency: currency)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .onReceive(viewModel.currencyHasChanged) {
            dismiss()
        }
        .errorBanner(isShown: $viewModel.shouldShowError,
                     message: viewModel.errorMessage)
    }
}


#Preview {
    @Previewable @State var user: UserProfileModel?
    NavigationStack {
        ChangeCurrencyView(viewModel: .init(userInfo: $user))
    }
}
