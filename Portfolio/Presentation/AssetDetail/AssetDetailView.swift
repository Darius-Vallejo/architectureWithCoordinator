//
//  AssetDetailView.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 26/12/24.
//

import SwiftUI

struct AssetDetailView: View {
    @StateObject var viewModel: AssetDetailViewModel
    @StateObject var navigatioAdapter: NavigationAdapterForAssetDetail = .init()

    var body: some View {
        NavigationStack(path: $navigatioAdapter.path) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    HorizontalImageCarousel(imageUrls: viewModel.asset.imagesURL)
                    Group {
                        AssetDetailTypeView(viewModel: viewModel)

                        Text("General info")
                            .font(.newBlackTypefaceExtraBold24)
                            .padding(.bottom, 16)

                        Group {
                            switch viewModel.asset.type {
                            case .car, .RV: generalInfoForCar
                            case .house: generalInfoForHouse
                            case .aircraft: generalInfoForAircraft
                            case .boat: generalInfoForBoat
                            case .lot: generalInfoForLot
                            }
                        }
                        .padding(.bottom, 8)
                    }
                    .padding(.horizontal, 16)
                }
            }
            .navigationDestination(for: AssetDetailViewModel.Navigation.self, destination: view(for:))
            .toolbar {
                toolBarGroup
            }
            .addBackButton(andPrincipalTitle: "Detail", isTransparent: false)
            .overlay(
                viewModel.isShowingMenu ? customMenuView : nil
            )
        }
        .environmentObject(navigatioAdapter)
    }

    var toolBarGroup: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            GeometryReader { geometry in
                Button(action: {
                    withAnimation(.linear) {
                        viewModel.isShowingMenu.toggle()
                    }
                    viewModel.buttonPosition = .init(x: geometry.frame(in: .global).minX - 46,
                                           y: geometry.frame(in: .global).maxY - 45)
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

    var customMenuView: some View {
        ZStack {

            VStack {}
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.1))
            .onTapGesture {
                viewModel.isShowingMenu = false
            }

            VStack(alignment: .leading, spacing: 5) {
                ForEach([AssetDetailViewModel.Navigation.attachment,
                         AssetDetailViewModel.Navigation.expenses], id: \.rawValue) { type in
                    menuItem(title: type.title, image: type.image, type: type)
                }
            }
            .padding(8)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 1)
            .frame(width: 180)
            .position(viewModel.buttonPosition)
        }
    }


    func menuItem(title: String, image: String, type: AssetDetailViewModel.Navigation) -> some View {
        Button {
            navigatioAdapter.path.append(type)
        } label: {
            HStack(spacing: 8) {
                Image(image)
                    .renderingMode(.template)
                    .frame(width: 16, height: 16)
                Text(title)
                    .font(Font.interDisplayRegular14)
                Spacer()
            }
            .foregroundColor(.blackPortfolio)
            .padding(8)
        }
    }


    var generalInfoForCar: some View {
        Group {
            generalInfoForType
            generalInfo(title: "Model", subtitle: viewModel.asset.assetDetails.model ?? .empty)
            if let vin = viewModel.asset.assetDetails.vin {
                generalInfo(title: "VIN", subtitle: vin)
            }
            generalInfo(title: "Mileage", subtitle: "\(viewModel.asset.assetDetails.mileage ?? 0)")
        }
    }

    var generalInfoForHouse: some View {
        Group {
            generalInfoForType
            if let date = viewModel.asset.assetDetails.dateOfConstruction {
                generalInfo(title: "Date of Construction", subtitle: date.formatDateToCustomString())
            }
            if let area = viewModel.asset.assetDetails.area {
                generalInfo(title: "Area", subtitle: "\(area)Mt2")
            }
        }
    }

    var generalInfoForAircraft: some View {
        Group {
            generalInfoForType
            if let make = viewModel.asset.assetDetails.make, !make.isEmpty {
                generalInfo(title: "Make", subtitle: "\(make)")
            }

            if let model = viewModel.asset.assetDetails.model, !model.isEmpty {
                generalInfo(title: "Model", subtitle: "\(model)")
            }
            if let tailNumber = viewModel.asset.assetDetails.tailNumber {
                generalInfo(title: "Tail Number", subtitle: tailNumber)
            }
            if let hoursFlown = viewModel.asset.assetDetails.hoursFlown {
                generalInfo(title: "Hours Flown", subtitle: "\(hoursFlown)h")
            }
        }
    }

    var generalInfoForBoat: some View {
        Group {
            generalInfoForType
            if let make = viewModel.asset.assetDetails.make, !make.isEmpty {
                generalInfo(title: "Make", subtitle: "\(make)")
            }

            if let model = viewModel.asset.assetDetails.model, !model.isEmpty {
                generalInfo(title: "Model", subtitle: "\(model)")
            }

            if let HIN = viewModel.asset.assetDetails.HIN {
                generalInfo(title: "Hull Identification Number", subtitle: HIN)
            }
            if let length = viewModel.asset.assetDetails.length {
                generalInfo(title: "Length", subtitle: "\(length)h")
            }
        }
    }

    var generalInfoForLot: some View {
        Group {
            generalInfoForType
            if let date = viewModel.asset.assetDetails.dateOfConstruction {
                generalInfo(title: "Date of Construction", subtitle: date.formatDateToCustomString())
            }
            if let area = viewModel.asset.assetDetails.area {
                generalInfo(title: "Area", subtitle: "\(area)Mt2")
            }

            if let zoning = viewModel.asset.assetDetails.zoning {
                generalInfo(title: "Zoning Information", subtitle: "\(zoning.title)")
            }
        }
    }

    var generalInfoForType: some View {
        Group {
            priceInfo(title: String.localized(.assetValue), subtitle: viewModel.formattedPrice)
            if viewModel.asset.costsPerMonth != 0 {
                generalInfo(title: "Cost per Month", subtitle: "\(viewModel.asset.costsPerMonth)")
            }
            if let date = viewModel.asset.dateOfPurchase {
                generalInfo(title: "Date of Purchase", subtitle: date.formatDateToCustomString())
            }
        }
    }

    func generalInfo(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.newBlackTypefaceRegular12)
                .foregroundStyle(Color.neutral300)

            Text(subtitle)
                .font(.newBlackTypefaceMedium20)
        }
    }

    func priceInfo(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.newBlackTypefaceRegular12)
                .foregroundStyle(Color.neutral300)
            Text(subtitle)
                .font(.newBlackTypefaceSemiBold32)
        }
    }


}

#Preview {
    AssetDetailView(viewModel: .init(asset:
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
                  assetDetails: .init(make: "", model: "", vin: "", mileage: 1000))))
}
