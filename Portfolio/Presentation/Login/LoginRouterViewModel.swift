//
//  LoginRouterViewModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 23/11/24.
//

import Combine
import UIKit
import Foundation

class LoginRouterViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var isSavedUser = false
    private var retriveSessionUseCase: RetriveSessionUseCaseProtocol
    private var fetchAssetsUseCase: FetchAssetsUseCaseProtocol
    
    init(
        retriveSessionUseCase: RetriveSessionUseCaseProtocol,
        fetchAssetsUseCase: FetchAssetsUseCaseProtocol
    ) {
        self.retriveSessionUseCase = retriveSessionUseCase
        self.fetchAssetsUseCase = fetchAssetsUseCase
    }

    func logout() {
        isLoading = false
        isSavedUser = false
    }
    
    func viewDidAppear() {
        fetchAssetsUseCase.loadCarMetadata()
        retriveSavedSession()
    }

    private func retriveSavedSession() {
        isLoading = true
        do {
            let sessionToken = try retriveSessionUseCase.execute()
            let session = sessionToken.getFullJWT()
            let sessionModel = SessionDomainMapper().mapFromDictionary(dictionary: session, tokenId: sessionToken.authToken)
            CurrentSessionHelper.shared.session = sessionModel
            isLoading = false
            isSavedUser = true
        } catch {
            isSavedUser = false
            isLoading = false
        }
    }

}
