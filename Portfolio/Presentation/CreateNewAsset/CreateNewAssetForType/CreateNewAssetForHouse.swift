//
//  CreateNewAssetForHouse.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 26/11/24.
//


import SwiftUI

struct CreateNewAssetForHouse: View {
    @StateObject var viewModel: CreateNewAssetForTypeViewModel

    init(viewModel: CreateNewAssetForTypeViewModel) {
        viewModel.saveAssetsUseCase = SaveAssetsUseCase(repository: HouseRepository())
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        DateSelectionView(selectedDate: $viewModel.dateOfConstruction,
                          focusedField: $viewModel.focusedField,
                          focusID: "CreateNewAssetForHouse-dropdown",
                          title: String.localized(.dateOfConstruction))

        FormCustomTextField(viewModel: viewModel.areaViewModel, type: .number)
    }
}
