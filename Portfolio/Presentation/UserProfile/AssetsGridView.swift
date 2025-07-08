//
//  AssetsGridView.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 21/12/24.
//

import SwiftUI

struct AssetsGridView: View {
    let items: [AssetDomainModel]
    let gridColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var detailView: ((_ item: AssetDomainModel) -> Void)? = nil
    var viewImageView: ((_ item: AssetDomainModel) -> Void)? = nil
    var refreshable: (() -> Void)? = nil

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: gridColumns, spacing: 20) {
                ForEach(items) { item in
                    ZStack {
                        // Background Image
                        CacheAsyncImage(urlString: item.imagesURL.first?.absoluteString ?? "",
                                        contentMode: .fill)
                        .frame(width: CreateNewAssetWithSelectedImagesConstants.Dimensions.imageWidth,
                               height: CreateNewAssetWithSelectedImagesConstants.Dimensions.imageHeight)
                        .clipShape(RoundedRectangle(cornerRadius: CreateNewAssetWithSelectedImagesConstants.Dimensions.imageCornerRadius))

                        VStack(alignment: .leading) {
                            /*
                            HStack {
                                Spacer()
                                ZStack {
                                    Circle()
                                        .fill(Color.yellowPortfolio)
                                        .frame(width: 32, height: 32)
                                    Image("assetListDetail")
                                        .renderingMode(.template)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 11, height: 11)
                                }
                                .onTapGesture {
                                    viewImageView?(item)
                                }
                            }*/
                            Spacer()
                            HStack {
                                Text(item.tag.title)
                                    .font(.interDisplayMedium10)
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 12)
                                    .background(Color.greenPortfolio)
                                    .cornerRadius(10)
                                    .padding(.top, 8)
                                Spacer()
                            }

                            HStack {
                                Text(item.title)
                                    .font(.molarumMedium16)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                    .padding(.top, 4)
                                    .shadow(radius: 2)
                                Spacer()
                            }
                        }
                        .padding(12)
                    }
                    .padding(.horizontal, 12)
                    .frame(height: CreateNewAssetWithSelectedImagesConstants.Dimensions.imageHeight)
                    .onTapGesture {
                        detailView?(item)
                    }
                }
            }
            .padding(.horizontal, 0)
        }
        .refreshable {
            refreshable?()
        }
    }
}


#Preview {
    AssetsGridView(items: [])
}
