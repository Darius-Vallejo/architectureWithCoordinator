//
//  ChangeDescriptionViewModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 4/12/24.
//



import SwiftUI
import Combine

class ChangeCurrencyViewModel: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var shouldShowError: Bool = false
    @Published var isLoading: Bool = false
    @Published var currency: CurrencyModel = .usd
    @Binding var userInfo: UserProfileModel?
    var currencyHasChanged = PassthroughSubject<Void, Never>()

    let updateUserCurrencyUseCase: UpdateUserCurrencyUseCaseProtocol

    init(userInfo: Binding<UserProfileModel?>,
         updateUserCurrencyUseCase: UpdateUserCurrencyUseCaseProtocol = UpdateUserCurrencyUseCase(repository: UserProfileRepository())) {
        self.updateUserCurrencyUseCase = updateUserCurrencyUseCase
        self._userInfo = userInfo
        self.currency = userInfo.wrappedValue?.currency ?? .usd
    }

    func checkIfCurrencyIsSelected(currency: CurrencyModel) -> Bool {
        return currency == self.currency
    }

    func changeCurrency(currency: CurrencyModel) {
        self.currency = currency
        isLoading = true
        Task {
            do {
                let userInfo = try await updateUserCurrencyUseCase.execute(currency: currency.rawValue)
                await MainActor.run {
                    self.userInfo = userInfo
                    self.shouldShowError = false
                    currencyHasChanged.send()
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to change the currency, there is an issue with this action. Please try again."
                    self.shouldShowError = true
                    isLoading = false
                }
            }
        }
    }
}
