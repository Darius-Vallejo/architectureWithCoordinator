//
//  AssetDetailViewModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 26/12/24.
//

import SwiftUI

class AssetDetailViewModel: ObservableObject {
    @Published var asset: AssetDomainModel
    @Published var isShowingMenu = false
    @Published var buttonPosition: CGPoint = .zero
    @Published var addNewAttachmentViewModel: AddNewAttachmentViewModel

    var currency: String = {
        CurrentSessionHelper.shared.user?.currency.rawValue  ?? CurrencyModel.usd.rawValue
    }()

    var formattedPrice: String {
        return String.formatToCurrency(asset.price, currencyCode: currency) ?? .empty
    }

    init(asset: AssetDomainModel) {
        self.asset = asset
        self.addNewAttachmentViewModel = AddNewAttachmentViewModel(assetId: asset.id)
    }
}


extension AssetDetailViewModel {
    enum Navigation: String {
        case attachment
        case expenses
        case addNewAttachment

        var title: String {
            switch self {
            case .attachment: String.localized(.attachment)
            case .expenses: String.localized(.expenseHistory)
            default: ""
            }
        }

        var image: String {
            switch self {
            case .attachment: "assetDetailToolbarAttachment"
            case .expenses: "assetDetailToolbarExpenses"
            default: ""
            }
        }
    }
}
