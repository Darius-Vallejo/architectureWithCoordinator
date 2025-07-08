//
//  NewAttachmentForExpense.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 25/01/25.
//

import SwiftUI

struct NewAttachmentForExpenseView: View {
    @StateObject var viewModel: NewAttachmentForExpenseViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                            .font(.newBlackTypefaceMedium16)
                            .foregroundStyle(Color.blackPortfolio)
                    }
                    Spacer()
                }
                .padding(10)

                if viewModel.attachmentId == nil {
                    attachmentButton
                        .padding(10)
                }

                if let pdfDocument = viewModel.pdfUrl {
                    PDFViewer(viewModel: viewModel.pdfViewerViewModel, url: pdfDocument)
                        .frame(maxWidth: .infinity)
                        .frame(height: 500)
                }

                if let pdfDocument = viewModel.remoteUrl {
                    PDFViewer(viewModel: viewModel.pdfViewerViewModel, url: pdfDocument)
                        .frame(maxWidth: .infinity)
                        .frame(height: 500)
                }
                Spacer()

            }

            VStack {
                Spacer()
                PrimaryButton(title: "Confirm Attachment",
                              allowDisableBackground: viewModel.pdfUrl != nil || viewModel.remoteUrl != nil) {
                    if let url = viewModel.pdfUrl {
                        viewModel.save?(.fromNewAttachment(url: url))
                    } else if let attachmentId = viewModel.attachmentId,
                              let remoteUrl = viewModel.remoteUrl {
                        viewModel.save?(.fromExistingAttachment(attachmentId: attachmentId,
                                                                remoteUrl: remoteUrl))
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.showDocumentPicker) {
            DocumentPicker { url in
                viewModel.pdfUrl = url
            }
        }
    }

    private var attachmentButton: some View {
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
    NewAttachmentForExpenseView(viewModel: .init())
}
