//
//  CreateNewAssetForAircraft.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 26/11/24.
//

import SwiftUI

struct CreateNewAssetForAircraft: View {
    @StateObject var viewModel: CreateNewAssetForTypeViewModel

    init(viewModel: CreateNewAssetForTypeViewModel) {
        viewModel.saveAssetsUseCase = SaveAssetsUseCase(repository: AircraftRepository())
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Group {
            FormCustomTextField(viewModel: viewModel.makeViewModel)
            FormCustomTextField(viewModel: viewModel.modelViewModel)
            FormCustomTextField(viewModel: viewModel.VINViewModel)
            FormCustomTextField(viewModel: viewModel.mileageViewModel, type: .number)
        }
    }
}
