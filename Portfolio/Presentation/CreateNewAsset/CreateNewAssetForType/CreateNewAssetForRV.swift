//
//  CreateNewAssetForRV.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 26/11/24.
//


import SwiftUI

struct CreateNewAssetForRV: View {
    @StateObject var viewModel: CreateNewAssetForTypeViewModel

    init(viewModel: CreateNewAssetForTypeViewModel) {
        viewModel.saveAssetsUseCase = SaveAssetsUseCase(repository: CarAssetRepository())
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        DropdownList(viewModel: viewModel.carBrandViewModel){
            viewModel.focusedField = "CreateNewAssetForRV-carBrandViewModel"
        }
        .id("CreateNewAssetForRV-carBrandViewModel")

        if let carModelViewModel = viewModel.carModelViewModel {
            DropdownList(viewModel: carModelViewModel) {
                viewModel.focusedField = "CreateNewAssetForRV-carModelViewModel"
            }
            .id("CreateNewAssetForRV-carModelViewModel")
        }

        FormCustomTextField(viewModel: viewModel.VINViewModel)
        FormCustomTextField(viewModel: viewModel.mileageViewModel, type: .number)
    }
}
