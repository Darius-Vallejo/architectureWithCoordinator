//
//  BannerType.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 23/11/24.
//

import SwiftUI

public enum BannerType: String, CaseIterable {
    case success
    case error
    case warning
    case information
	case successWithDismiss

    func color() -> Color {
        switch self {
        case .error: .danger700
        default: .gray
        }
    }
}

public struct BannerModel: Equatable {
    public var type: BannerType
    public var message: String
    public var accessibilityMessage: String?
    public var hasAction: Bool?
    public var actionButtonLabel: String?
    public var hideCloseButton: Bool?

    public init(type: BannerType, message: String, accessibilityMessage: String? = nil, hasAction: Bool? = nil, actionButtonLabel: String? = nil, hideCloseButton: Bool? = nil) {
        self.type = type
        self.message = message
        self.accessibilityMessage = accessibilityMessage
        self.hasAction = hasAction
        self.actionButtonLabel = actionButtonLabel
        self.hideCloseButton = hideCloseButton
    }

    public static func == (lhs: BannerModel, rhs: BannerModel) -> Bool {
        return lhs.type == rhs.type &&
        lhs.message == rhs.message &&
        lhs.hasAction == rhs.hasAction &&
        lhs.hideCloseButton == rhs.hideCloseButton
    }
}
