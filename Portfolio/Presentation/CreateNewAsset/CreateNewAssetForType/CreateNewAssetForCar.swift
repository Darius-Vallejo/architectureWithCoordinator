//
//  CreateNewAssetForCar.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 26/11/24.
//


import SwiftUI

struct CreateNewAssetForCar: View {
    @StateObject var viewModel: CreateNewAssetForTypeViewModel


    var body: some View {
        DropdownList(viewModel: viewModel.carBrandViewModel) {
                viewModel.focusedField = "CreateNewAssetForCar-marketTagDropdown"
            }
            .id("CreateNewAssetForCar-marketTagDropdown")

        if let carModelViewModel = viewModel.carModelViewModel {
            DropdownList(viewModel: carModelViewModel) {
                    viewModel.focusedField = "CreateNewAssetForCar-marketTagDropdown2"
                }
                .id("CreateNewAssetForCar-marketTagDropdown2")
        }

        FormCustomTextField(viewModel: viewModel.VINViewModel)
        FormCustomTextField(viewModel: viewModel.mileageViewModel, type: .number)
    }
}
