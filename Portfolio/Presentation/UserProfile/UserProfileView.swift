//
//  UserProfileView.swift
//  portfolio
//
//  Created by Dario Fernando Vallejo Posada on 20/11/24.
//

import SwiftUI

struct UserProfileView: View {
    
    @ObservedObject var viewModel: UserProfileViewModel
    @ObservedObject var navigationAdapterForSettings: NavigationAdapterForSettings = .init()
    @ObservedObject var modalAdapter: UserProfileViewModalAdapter = .init()
    let coordinator: UserProfileCoordinatorProtocol
    
    init(viewModel: UserProfileViewModel, coordinator: UserProfileCoordinatorProtocol) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }
    @Namespace private var profileImageNamespace
    @Namespace private var profileImageNamespaceId

    var body: some View {
        NavigationStack(path: $navigationAdapterForSettings.path) {
            ZStack {
                headerView
                profileImageView
                contentView
            }
            .background(Color.white)
            .ignoresSafeArea(edges: [.top, .leading, .trailing])
            .toolbar {
                toolBarGroup
            }
            .navigationDestination(for: UserProfileViewModel.NavigationDestination.self, destination: view(for:))
            .overlay(
                viewModel.isShowingNewAssetMenu ? customMenuView : nil
            )
            .overlay(expandedProfileImageView)
        }
        .fullScreenCover(item: $modalAdapter.newAseetModalObject.presentModal) { item in
            CreateNewAssetView(
                viewModel: .init(
                    assetType: modalAdapter.newAseetModalObject.presentModal?.type ?? .house
                ),
                navigationAdapter: .init(didCreateAssetSuccessfully: { [weak viewModel] assetType in
                    viewModel?.didSaveNewAsset(type: assetType)
                    let adapter = ModalAdapter<NewAssetModel>()
                    adapter.presentModal = nil
                    modalAdapter.newAseetModalObject = adapter
                })
            )
        }
        .fullScreenCover(item: $modalAdapter.assetDetailObject.presentModal) { item in
            AssetDetailView(viewModel: .init(asset: item))
        }
        .onAppear {
            viewModel.fetchUserProfile()
            viewModel.fetchAssets()
            setupNavigationBarAppearance(isTransparent: true)
        }
        .environmentObject(navigationAdapterForSettings)
        .environmentObject(modalAdapter)
    }

    var expandedProfileImageView: some View {
        Group {
            if viewModel.isProfileImageExpanded {
                    if let image = viewModel.image {
                    ZStack {
                        Color.black
                            .opacity(0.95)
                            .blur(radius: 1)
                            .ignoresSafeArea()
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: 250, maxHeight: 250)
                            .clipShape(Circle())
                            .matchedGeometryEffect(id: profileImageNamespaceId, in: profileImageNamespace)
                            .transition(.scale)
                    }
                    .onTapGesture {
                        withAnimation(.linear) {
                            viewModel.isProfileImageExpanded = false
                        }
                    }
                }
            }
        }
    }

    var headerView: some View {
        VStack {
            Rectangle()
            .fill(Color.yellowPortfolio)
            .frame(maxWidth: .infinity)
            .frame(height: 128)
            Spacer()
        }
    }

    var profileImageView: some View {
        VStack {
            if !viewModel.isProfileImageExpanded {
                if let selectedImage = viewModel.userProfile?.profilePicture, !viewModel.isLoading {
                    AsyncImage(url: URL(string: selectedImage))
                    { result in
                        viewModel.image = result.image
                        return result.image?
                            .resizable()
                            .scaledToFill()
                    }
                    .frame(width: 112, height: 112)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.yellowPortfolio, lineWidth: 4)
                    )
                    .matchedGeometryEffect(id: profileImageNamespaceId, in: profileImageNamespace)
                    .onTapGesture {
                        withAnimation(.linear) {
                            viewModel.isProfileImageExpanded = true
                        }
                    }
                } else {
                    Circle()
                        .fill(.gray)
                        .frame(width: 112, height: 112)
                        .overlay(
                            Circle()
                                .stroke(Color.yellowPortfolio, lineWidth: 4)
                        )
                }
                Spacer()
            }
        }
        .padding(.top, 72)
    }
    
    var contentView: some View {
        VStack {
            titleContainerView
            gridContainerView
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 200)
        .padding(.horizontal, 16)
    }
    
    var titleContainerView: some View {
        VStack {
            Text(viewModel.fullName)
                .font(Font.newBlackTypefaceExtraBold24)
                .foregroundStyle(Color.blackPortfolio)

            Text(viewModel.nickName)
                .font(Font.newBlackTypefaceMedium16)
                .foregroundStyle(Color.blackPortfolio)

            Text(viewModel.userDescription)
                .foregroundStyle(Color.blackPortfolio)
                .font(Font.newBlackTypefaceMedium12)
                .padding(.top, 1)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 116)
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color.gray)
                .padding(.top, nil),
            alignment: .bottom
        )
    }

    @ViewBuilder
    var gridContainerView: some View {
        if viewModel.assetList.isEmpty {
            emptyView
        } else {
            AssetsGridView(items: viewModel.assetList, detailView: { item in
                let adapter = ModalAdapter<AssetDomainModel>()
                adapter.presentModal = item
                modalAdapter.assetDetailObject = adapter
            }, viewImageView: { item in
                
            }, refreshable: {
                viewModel.fetchAssets()
            })

        }
    }
    
    var emptyView: some View {
        ScrollView {
            VStack {
                Image("pIcon")
                    .renderingMode(.template)
                    .foregroundStyle(Color.greyPortfolio)
                Text(String.localized(.noContentYet))
                    .font(Font.newBlackTypefaceMedium16)
                    .foregroundStyle(Color.greyPortfolio)
                Spacer()
            }
            .padding(.vertical, 50)
        }
        .refreshable {
            viewModel.fetchAssets()
        }
    }
    
    var customMenuView: some View {
        ZStack {

            VStack {}
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.1))
            .onTapGesture {
                viewModel.isShowingNewAssetMenu = false
            }

            VStack(alignment: .leading, spacing: 5) {
                ForEach(AssetType.allCases, id: \.rawValue) { asset in
                    menuItem(title: asset.text, image: viewModel.getIconFromType(type: asset), type: asset)
                }
            }
            .padding(8)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 1)
            .frame(width: 145)
            .position(viewModel.buttonPosition)
        }
    }
    
    func menuItem(title: String, image: String, type: AssetType) -> some View {
        Button {
            let adapter = ModalAdapter<NewAssetModel>()
            adapter.presentModal = .init(type: type)
            modalAdapter.newAseetModalObject = adapter
            viewModel.isShowingNewAssetMenu = false
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

    var toolBarGroup: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            GeometryReader { geometry in
                Button(action: {
                    withAnimation(.linear) {
                        viewModel.isShowingNewAssetMenu.toggle()
                    }
                    viewModel.buttonPosition = .init(x: geometry.frame(in: .global).minX + 10,
                                           y: geometry.frame(in: .global).maxY + 18)
                }) {
                    Image("profilePlusIcon")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 32, height: 32)
                }
            }
            .frame(width: 40, height: 40)

            NavigationLink(value: UserProfileViewModel.NavigationDestination.settings) {
                Image("profileMoreIcon")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 20, height: 20)

            }
        }
    }
}

#Preview {
    UserProfileCoordinatorFactory.create().makeUserProfileView()
}

