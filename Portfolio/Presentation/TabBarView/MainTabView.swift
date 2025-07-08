//
//  MainTabView.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 14/12/24.
//


import SwiftUI

struct MainTabView: View {

    @State private var selectedTab: MainTabType = .profile

    var body: some View {
        TabView(selection: $selectedTab) {
           /* UserProfileView()
                .tabItem {
                    tabItemViewI(type: .profile)
                }
                .tag(MainTabType.profile)*/

            SearchView()
                .tabItem {
                    tabItemViewI(type: .search)
                }

            FeedView()
                .tabItem {
                    tabItemViewI(type: .feed)
                }

            InvestView()
                .tabItem {
                    tabItemViewI(type: .investment)
                }
        }
    }

    func tabItemViewI(type: MainTabType) -> some View {
        VStack {
            Image(type.icon)
                .renderingMode(.template)
                .foregroundStyle(selectedTab == type ? Color.blackPurplePortfolio : Color.lightGreyPortfolio)
            Text(type.title)
                .font(.interDisplayMedium10)
                .foregroundStyle(selectedTab == type ? Color.blackPurplePortfolio : Color.lightGreyPortfolio)
        }
    }
}



struct SearchView: View {
    var body: some View {
        Text("Search View")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
    }
}

struct FeedView: View {
    var body: some View {
        Text("Feed View")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
    }
}

struct InvestView: View {
    var body: some View {
        Text("Invest View")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
    }
}

enum MainTabType: Hashable {
    case profile
    case search
    case feed
    case investment

    var icon: String {
        switch self {
        case .profile: "tabUserIcon"
        case .search: "tabSearchIcon"
        case .feed: "tabFeedIcon"
        case .investment: "tabInvestmentIcon"
        }
    }

    var title: String {
        switch self {
        case .profile: String.localized(.profile)
        case .search: String.localized(.search)
        case .feed: String.localized(.feed)
        case .investment: String.localized(.invest)
        }
    }
}
