//
//  AttachmentViewContent.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 25/01/25.
//

import SwiftUI

struct AttachmentViewContent: View {

    @StateObject var viewModel: AttachmentViewModel
    var primaryButtonAction: ()->Void

    var body: some View {
        ZStack {
            if viewModel.attachments.isEmpty {
                emptyState
            } else {
                listOfAttachments
                VStack {
                    Spacer()
                    PrimaryButton(title: "Attach New Document") {
                        primaryButtonAction()
                    }
                }
            }
        }
        .if(viewModel.isShowingNewAssetMenu, transform: { ztack in
            ztack.overlay(
                    CustomMenuView(
                           isShown: $viewModel.isShowingNewAssetMenu,
                           position: viewModel.buttonPosition,
                           items: viewModel.customMenuItems,
                           backgroundOpacity: 0.1,
                           menuWidth: 145,
                           cornerRadius: 12,
                           shadowRadius: 1
                       )
                )
        })
        .addBackButton(andPrincipalTitle: String.localized(.attachment), isTransparent: true)
        .onAppear {
            viewModel.loadListOfAttachments()
        }
        .asyncLoadingOverlay(isPresented: $viewModel.isLoading, message: "Loading...")
        .fullScreenCover(item: $viewModel.attachmentToPresent) { attachment in
            AttachmentDetailWithNavigtionView(viewModel: .init(attachment: attachment) {
                viewModel.attachmentToPresent = nil
                viewModel.loadListOfAttachments()
            })
        }

    }


    var emptyState: some View {
        VStack {
            Spacer()

            VStack {
                Image("attachmentEmptyState")
                    .renderingMode(.template)
                    .scaledToFit()
                    .foregroundStyle(Color.neutralGray200)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(Color.neutralGray)
                            .frame(width: 112, height: 112)
                    )
                    .padding(32)

                Text(String.localized(.attachmentTitle))
                    .font(Font.newBlackTypefaceSemiBold32)
                Text(String.localized(.attachmentDescription))
                    .font(Font.newBlackTypefaceRegular16)
            }
            .padding(.horizontal, 20)

            Spacer()

            PrimaryButton(title: "Attach New Document") {
                primaryButtonAction()
            }
        }
    }

    var listOfAttachments: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.attachments, id: \.id) { item in
                    attachmentItem(attachment: item)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    func attachmentItem(attachment: AttachmentDomainModel) -> some View {
        HStack {
            Image("attachmentItemIcon")
                .frame(width: 64, height: 64)
                .background(
                    Rectangle()
                        .fill(Color.yellowPortfolio.opacity(0.4))
                        .frame(width: 64, height: 64)
                        .roundedRectangle(cornerRadius: 12)
                )

            VStack(alignment: .leading, spacing: 8) {
                Text(attachment.name)
                    .font(.newBlackTypefaceRegular16)
                    .foregroundStyle(Color.blackPortfolio)
                HStack {
                    Text(attachment.type.rawValue.capitalized)
                        .foregroundStyle(Color.blackPortfolio)
                        .font(.interDisplayMedium10)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 10)
                        .background(Color.greenPortfolio)
                        .cornerRadius(16)

                    Text("PDF")
                        .foregroundStyle(Color.blackPortfolio)
                        .font(.interDisplayLight16)
                }

            }
            .padding(.leading, 8)

            Spacer()
            GeometryReader { geometry in
                Button {
                    viewModel.customMenuItems = [
                                CustomMenuItem(
                                    title: "Delete",
                                    image: "deleteAttachmentIcon",
                                    textColor: .danger700,
                                    action: {
                                        viewModel.deleteExpense(attachment: attachment)
                                    }
                                )
                       ]
                    withAnimation(.linear) {
                        viewModel.isShowingNewAssetMenu.toggle()
                    }
                    viewModel.buttonPosition = .init(x: geometry.frame(in: .global).minX - 10,
                                                     y: geometry.frame(in: .global).maxY + 30)
                } label: {
                    Image("viewMoreButton")
                }
                .frame(width: 36, height: 36, alignment: .center)
            }
            .frame(width: 36, height: 36, alignment: .center)


        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .roundedRectangle(cornerRadius: 10,
                          borderColor: .lightGreyPortfolio,
                          borderLine: 0.5)
        .onTapGesture {
            viewModel.onTapOnItem(attachment: attachment)
        }
    }

}


#Preview {
    AttachmentViewContent(viewModel: .init(assetId: 0,
                                    attachments: [
        .init(id: 1,
              name: "Lorem ipsum",
              value: 200,
              date: nil,
              description: nil,
              type: .improvement,
              isCreatedAsAttachment: true,
              attachmentURL: nil,
              attachmentId: 2),
        .init(id: 3,
              name: "Lorem ipsum",
              value: 200,
              date: nil,
              description: nil,
              type: .improvement,
              isCreatedAsAttachment: true,
              attachmentURL: nil,
              attachmentId: 2),
        .init(id: 2,
              name: "Lorem ipsum",
              value: 200,
              date: nil,
              description: nil,
              type: .maintenance,
              isCreatedAsAttachment: true,
              attachmentURL: nil,
              attachmentId: 2)
                                    ]), primaryButtonAction: {

                                    })
}
