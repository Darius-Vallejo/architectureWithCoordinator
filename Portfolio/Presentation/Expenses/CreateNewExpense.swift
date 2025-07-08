//
//  CreateNewExpense.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 25/01/25.
//


import SwiftUI
import PDFKit

struct CreateNewExpense: View {

    @StateObject var viewModel: CreateNewExpenseViewModel
    @EnvironmentObject var navigationAdapter: NavigationAdapterForExpenseDetail

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                formView
                Divider()

                Spacer()
                PrimaryButton(title: "Save Attachment",
                              allowDisableBackground: viewModel.isSaveButtonEnabled) {
                    viewModel.saveAttachment()
                }
                .disabled(!viewModel.isSaveButtonEnabled)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
        .asyncLoadingOverlay(
            isPresented: $viewModel.isLoading,
            message: "Saving attachment"
        )
        .banner(
            isShown: $viewModel.showErrorAlert,
            type: .error,
            message: viewModel.formError
        )
        .addBackButton(andPrincipalTitle: "Add Expense", isTransparent: true)
    }

    var formView: some View {
        VStack(spacing: 8) {
            FormCustomTextField(viewModel: viewModel.expenseName)
            FormCustomTextField(viewModel: viewModel.expenseValue, type: .number)
            DateSelectionView(selectedDate: $viewModel.date,
                              focusedField: $viewModel.focosId,
                              isAlreadyEdited: $viewModel.isDateAlreadyEdited,
                              title: "Expense Date",
                              minimumDate: viewModel.minimumDate?.minDate,
                              maximumDate: viewModel.minimumDate?.maxDate)
            DropdownList(viewModel: viewModel.typeAttachment)
            FormCustomTextField(viewModel: viewModel.description,
                                axis: .vertical)
            .lineLimit(2...7)
            attachmentButton

            if let pdfDocument = viewModel.pdfUrl {
                PDFViewer(viewModel: viewModel.pdfViewerViewModel, url: pdfDocument)
                    .frame(maxWidth: .infinity)
                    .frame(height: 400)
            }

            if let pdfDocument = viewModel.remoteUrl {
                PDFViewer(viewModel: viewModel.pdfViewerViewModel, url: pdfDocument)
                    .frame(maxWidth: .infinity)
                    .frame(height: 400)
            }
            Spacer()
            Spacer()
        }
    }

    var attachmentButton: some View {
        Button(action: {
            hideKeyboard()
            navigationAdapter.path.append(ExpenseDetailViewModel.Navigation.attachmentSelect)
        }) {
            HStack {
                Text("Attach Document (Optional)")
                    .foregroundColor(.greyPortfolio)

                Spacer()

                Image("attachmentIcon")
            }
            .font(CustomTextFieldConstants.Fonts.textFieldFont)
            .padding(.horizontal, CustomTextFieldConstants.Dimensions.horizontalPadding)
            .padding(.vertical, CustomTextFieldConstants.Dimensions.verticalPadding)
            .background(
                RoundedRectangle(cornerRadius: CustomTextFieldConstants.Dimensions.cornerRadius)
                    .stroke(CustomTextFieldConstants.Colors.borderColor, lineWidth: CustomTextFieldConstants.Dimensions.borderLineWidth)
            )
        }
    }
}

#Preview {
    CreateNewExpense(viewModel: .init(assetId: 0,
                                      date: .now))
}
