//
//  CreateNewAssetForLot.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 30/12/24.
//

import SwiftUI

struct CreateNewAssetForLot: View {
    @StateObject var viewModel: CreateNewAssetForTypeViewModel

    init(viewModel: CreateNewAssetForTypeViewModel) {
        viewModel.saveAssetsUseCase = SaveAssetsUseCase(repository: LotRepository())
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        DropdownList(viewModel: viewModel.zoningViewModel){
            viewModel.focusedField = "CreateNewAssetForLot-zoningViewModel"
        }
        .id("CreateNewAssetForLot-zoningViewModel")
        FormCustomTextField(viewModel: viewModel.areaViewModel)
    }
}
