//
//  AddNewAttachmentView.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 6/01/25.
//


import SwiftUI
import PDFKit

struct UpdateAttachmentView: View {

    @EnvironmentObject var navigatioAdapter: NavigationAdapterForAssetDetail
    @StateObject var viewModel: UpdateAttachmentViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Edit Document")
                    .font(Font.newBlackTypefaceSemiBold32)
                Text("Please update the info as you need")
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
                    viewModel.setAttachmentUrl(url: url)
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
    UpdateAttachmentView(viewModel: .init(attachment: .init(id: 0,
                                                            name: "Example",
                                                            value: 2000,
                                                            date: .now,
                                                            description: "Somehting",
                                                            type: .appraisal,
                                                            isCreatedAsAttachment: true,
                                                            attachmentURL: .init(string: "https://portafolio-documents.s3.us-east-1.amazonaws.com/documents/4_1736888394831.pdf"),
                                                            attachmentId: 2),
                                          onSave: { _ in

    }))
}
