//
//  CreateNewAssetForTypeView.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 14/12/24.
//

import SwiftUI

struct CreateNewAssetForTypeView: View {
    typealias Dimensions = CreateNewAssetForTypeConstants.Dimensions
    typealias Colors = CreateNewAssetForTypeConstants.Colors
    typealias Fonts = CreateNewAssetForTypeConstants.Fonts
    typealias Assets = CreateNewAssetForTypeConstants.Assets

    @StateObject var viewModel: CreateNewAssetForTypeViewModel
    @EnvironmentObject var modalAdapter: UserProfileViewModalAdapter

    var body: some View {
        content
    }

    @ViewBuilder
    private var formFieldsByType: some View {
        switch viewModel.assetType {
        case .car: CreateNewAssetForCar(viewModel: viewModel)
        case .RV: CreateNewAssetForRV(viewModel: viewModel)
        case .aircraft: CreateNewAssetForAircraft(viewModel: viewModel)
        case .boat: CreateNewAssetForBoat(viewModel: viewModel)
        case .house: CreateNewAssetForHouse(viewModel: viewModel)
        case .lot: CreateNewAssetForLot(viewModel: viewModel)
        }
    }

    private var content: some View {
        ScrollViewReader { proxy in
            VStack {
                ScrollView {
                    formfields
                        .onChange(of: viewModel.focusedField) { _, newValue in
                            guard let id = newValue else { return }
                            withAnimation {
                                proxy.scrollTo(id, anchor: .center)
                            }
                        }
                }
                Divider()
                VStack {
                    PrimaryButton(
                        title: String.localized(.save),
                        allowDisableBackground: viewModel.isButtonEnabled
                    ) {
                        viewModel.saveAsset()
                    }
                    .disabled(viewModel.showErrorAlert)
                    .padding(.vertical, Dimensions.buttonVerticalPadding)
                }
            }
            .background(Colors.backgroundColor)
            .padding(.horizontal, Dimensions.horizontalPadding)
            .addBackButton(andPrincipalTitle: viewModel.assetType.navigationTitle, isTransparent: false)
            .addDoneButtonToNavigation(title: String.localized(.close), actionBeforeDismiss: {
                let adapter = ModalAdapter<NewAssetModel>()
                adapter.presentModal = nil
                modalAdapter.newAseetModalObject = adapter
            })
            .banner(
                isShown: $viewModel.showErrorAlert,
                type: .error,
                message: viewModel.formError
            )
            .asyncLoadingOverlay(
                isPresented: $viewModel.isSavingAsset,
                message: viewModel.savingAssetMessage
            )
            .task {
                await viewModel.viewDidLoad()
            }
        }
    }

    private var formfields: some View {
        VStack {
            privacyToggleRow(iconName: Assets.Icons.settingsAccount,
                             iconColor: Colors.toggleIconColor,
                             title: String.localized(.makeYourAssetPrivate),
                             isOn: $viewModel.isPrivate)

            if !viewModel.isPrivate {
                DropdownList(viewModel: viewModel.marketTagViewModel)
                    .hideKeyboardOnTap()
                    .id("marketTagDropdown")
                    .onTapGesture {
                        viewModel.focusedField = "marketTagDropdown"
                    }
            }
            FormCustomTextField(viewModel: viewModel.priceViewModel, type: .currency)
            FormCustomTextField(viewModel: viewModel.titleViewModel)
            FormCustomTextField(viewModel: viewModel.costPerMonthViewModel, type: .currency)
            FormCustomTextField(viewModel: viewModel.descriptionViewModel,
                                axis: .vertical)
            .lineLimit(2...7)

            DateSelectionView(selectedDate: $viewModel.dateOfPurchase,
                              focusedField: $viewModel.focusedField,
                              focusID: "dateOfPurchase",
                              title: String.localized(.dateOfPurchase))
            formFieldsByType
        }
    }


    private func privacyToggleRow(iconName: String,
                                  iconColor: Color,
                                  title: String,
                                  isOn: Binding<Bool>) -> some View {
        HStack {
            Circle()
                .fill(iconColor.opacity(Dimensions.iconBackgroundOpacity))
                .frame(width: Dimensions.iconBackgroundSize, height: Dimensions.iconBackgroundSize)
                .overlay(
                    Image(iconName)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .foregroundColor(Colors.toggleIconForegroundColor)
                        .frame(width: Dimensions.iconSize, height: Dimensions.iconSize)
                )

            Text(title)
                .font(Fonts.titleFont)
                .foregroundColor(Colors.titleColor)
                .padding(.vertical, Dimensions.titleVerticalPadding)

            Spacer()

            Toggle(String.empty, isOn: isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: Colors.toggleTintColor))
        }
        .padding(.horizontal, Dimensions.rowHorizontalPadding)
        .frame(height: Dimensions.rowHeight)
    }
}

#Preview {
    CreateNewAssetForTypeView(viewModel: .init(assetType: .car, recentImages: []))
}
