//
//  AddNewAttachmentView.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 6/01/25.
//


import SwiftUI
import PDFKit

struct AddNewAttachmentView: View {

    @EnvironmentObject var navigatioAdapter: NavigationAdapterForAssetDetail
    @StateObject var viewModel: AddNewAttachmentViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(String.localized(.addNewDocument))
                    .font(Font.newBlackTypefaceSemiBold32)
                Text(String.localized(.newAttachmentDescription))
                    .font(Font.newBlackTypefaceRegular16)
                formView
                Divider()

                Spacer()
                PrimaryButton(title: "Save Attachment",
                              allowDisableBackground: viewModel.isSaveButtonEnabled) {
                    viewModel.saveAttachment()
                }
                .disabled(!viewModel.isSaveButtonEnabled)
            }
            .sheet(isPresented: $viewModel.showDocumentPicker) {
                DocumentPicker { url in
                    viewModel.pdfUrl = url
                }
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
        .addBackButton(andPrincipalTitle: "Attach New Document", isTransparent: true)
    }

    var formView: some View {
        VStack(spacing: 8) {
            FormCustomTextField(viewModel: viewModel.expenseName)
            FormCustomTextField(viewModel: viewModel.expenseValue, type: .number)
            DateSelectionView(selectedDate: $viewModel.date,
                              focusedField: $viewModel.focosId,
                              isAlreadyEdited: $viewModel.isDateAlreadyEdited,
                              title: "Expense Date (Optional)")
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
            Spacer()
        }
    }

    var attachmentButton: some View {
        Button(action: {
            hideKeyboard()
            viewModel.showDocumentPicker.toggle()
        }) {
            HStack {
                Text("Attach Document")
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
    NavigationStack {
        AddNewAttachmentView(viewModel: .init(assetId: 2))
    }
}
