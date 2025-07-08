//
//  AttachmentDetailView.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 17/01/25.
//

import SwiftUI

struct AttachmentDetailView: View {
    @StateObject var viewModel: AttachmentDetailViewModel

    var body: some View {
        VStack(spacing: 0) {
            Divider()

            // MARK: Content Scroll
            contentView
        }
        .addBackButton(andPrincipalTitle: "Expense Detail")
        .toolbar {
            toolBarGroup
        }
        .overlay(customMenuView)
        .asyncLoadingOverlay(isPresented: $viewModel.isLoading, message: "Loading...")
    }

    var customMenuView: some View {
        CustomMenuView(
               isShown: $viewModel.isShowingMenu,
               position: viewModel.buttonPosition,
               items: [
                CustomMenuItem(
                    title: "Edit",
                    image: "editAttachmentIcon",
                    textColor: .blackPortfolio,
                    action: {
                        viewModel.onOpenDetail?()
                    }
                ),
                CustomMenuItem(
                    title: "Delete",
                    image: "deleteAttachmentIcon",
                    textColor: .danger700,
                    action: {
                        viewModel.deleteExpense()
                    }
                )
               ],
               backgroundOpacity: 0.1,
               menuWidth: 130,
               cornerRadius: 12,
               shadowRadius: 1
           )
    }

    func menuItem(title: String, image: String, textColor: Color) -> some View {
        Button {
            viewModel.isShowingMenu = false
        } label: {
            HStack(spacing: 8) {
                Image(image)
                    .frame(width: 16, height: 16)
                Text(title)
                    .font(Font.interDisplayRegular14)
                    .foregroundStyle(textColor)
                Spacer()
            }
            .foregroundColor(.blackPortfolio)
            .padding(8)
        }
    }

    var toolBarGroup: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            GeometryReader { geometry in
                Button(action: {
                    withAnimation(.linear) {
                        viewModel.isShowingMenu.toggle()
                    }
                    viewModel.buttonPosition = .init(x: geometry.frame(in: .global).minX - 20,
                                           y: geometry.frame(in: .global).maxY + 30)
                }) {
                    Image("profileMoreIcon")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)

                }
            }
            .frame(width: 40, height: 40)
        }
    }

    var contentView: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {

                // Title + Value
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.attachment.name)
                            .font(.newBlackTypefaceSemiBold32)

                        Text(String.localized(.date))
                            .font(.interDisplayMedium12)
                            .foregroundColor(.blackPortfolio)
                        // Yellow date chip
                        Text(viewModel.dateFormatted)
                            .font(.interDisplayRegular10)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .foregroundColor(.yellowPortfolio)
                            )
                    }

                    Spacer()

                    // Expense Value
                    VStack(alignment: .trailing) {
                        Text(String.localized(.expenseValue))
                            .font(.interDisplayRegular12)
                            .foregroundColor(.blackPortfolio)

                        Text(viewModel.formattedPrice)
                            .font(.newBlackTypefaceBold24)
                    }
                    .padding(.top, 2)
                }

                Divider()

                // Large Rectangular Area for PDF or Gray Box
                if viewModel.attachment.attachmentURL != nil {
                    pdfContainer
                } else {
                    ZStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(height: 700)
                        Text("No attachment yet")
                            .font(.newBlackTypefaceMedium16)
                            .foregroundStyle(Color.greyPortfolio)
                    }
                }

                Spacer(minLength: 16)
            }
            .padding()
        }
    }

    var pdfContainer: some View {
        ZStack(alignment: .topTrailing) {
            Button {

            } label: {
                if let pdfDocument = viewModel.pdfViewModel.pdfUrl {
                    PDFViewer(viewModel: viewModel.pdfViewModel,
                              url: pdfDocument)
                        .frame(maxWidth: .infinity)
                        .frame(height: 700)
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.4))
                        .frame(height: 700)
                        .overlay(
                            ProgressView("Loading PDF...")
                                .progressViewStyle(CircularProgressViewStyle())
                        )
                }
            }

            /*
            // Pencil/Edit icon
            Button {

            } label: {
                Image(systemName: "pencil")
                    .foregroundStyle(Color.blackPortfolio)
                    .padding(8)
                    .offset(x: -12, y: 12)
            }*/
        }
    }
}

// MARK: - Preview
struct ExpenseDetailDesignView_Previews: PreviewProvider {
    static var previews: some View {
        AttachmentDetailView(viewModel:
                .init(attachment: .init(id: 1,
                                        name: "Lorem ipsum dolor sit",
                                        value: 0,
                                        date: .now,
                                        description: nil,
                                        type: .appraisal,
                                        isCreatedAsAttachment: true,
                                        attachmentURL: .init(string: "https://portafolio-documents.s3.us-east-1.amazonaws.com/documents/4_1736888394831.pdf"),
                                        attachmentId: 2)))
    }
}
