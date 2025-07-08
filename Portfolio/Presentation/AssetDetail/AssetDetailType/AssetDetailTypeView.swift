//
//  AssetDetailTypeView.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 6/01/25.
//

import SwiftUI

struct AssetDetailTypeView: View {

    @StateObject var viewModel: AssetDetailViewModel

    var body: some View {
        Group {
            Text(viewModel.asset.title)
                .font(.newBlackTypefaceSemiBold32)

            if !viewModel.asset.description.isEmpty {
                Text(viewModel.asset.description)
                    .font(.newBlackTypefaceRegular16)
                    .padding(.bottom, 10)
            }

            AssetDetailTagsTypeView(viewModel: viewModel)
        }
    }
}

struct AssetDetailTagsTypeView: View {

    @StateObject var viewModel: AssetDetailViewModel

    var body: some View {
        HStack {
            Text(viewModel.asset.type.text)
                .font(.interDisplayMedium12)
                .padding(.vertical, 4)
                .padding(.horizontal, 34)
                .frame(maxWidth: .infinity)
                .background(Color.yellowPortfolio)
                .cornerRadius(10)
            Spacer()
            Text(viewModel.asset.tag.title)
                .font(.interDisplayMedium12)
                .padding(.vertical, 4)
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity)
                .background(Color.yellowPortfolio)
                .cornerRadius(10)
            Spacer()
            Text(String.localized(viewModel.asset.isPrivate ? .privateTitle : .publicTitle))
                .font(.interDisplayMedium12)
                .padding(.vertical, 4)
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity)
                .background(Color.yellowPortfolio)
                .cornerRadius(10)
        }
        .padding(.bottom, 10)
        .padding(.top, 3)
    }
}

#Preview {
    let viewModel: AssetDetailViewModel =   .init(asset:
            .init(id: 1,
                  type: .car,
                  price: 20000,
                  isPrivate: false,
                  costsPerMonth: 30000,
                  title: "Toyota Camry 2021 - Updated",
                  description: "Lorem ipsum dolor et sit amet",
                  dateOfPurchase: .now,
                  imagesURL: [URL(string: "https://portafolio-documents.s3.us-east-1.amazonaws.com/images/4_1734745099869.png")!],
                  imagesContent: [],
                  tag: .sell,
                  assetDetails: .init(make: "", model: "", vin: "", mileage: 1000)))
    AssetDetailTagsTypeView(viewModel: viewModel)
}
