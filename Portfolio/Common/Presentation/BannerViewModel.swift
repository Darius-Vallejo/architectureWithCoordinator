//
//  BannerViewModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 23/11/24.
//


import Foundation
import SwiftUI

public class BannerViewModel: ObservableObject {
    @Published public var model: BannerModel
    @Published public var elapsedSeconds: Double = 0.0
    public var timer = Timer()
    public var messageMaxLength: Int?
    public init(model: BannerModel, messageMaxLength: Int? = 250) {
        self.model = model
        self.messageMaxLength = messageMaxLength
    }

    public var bannerIconName: String {
        return model.type.rawValue
    }

    public var bannerBrushImageName: String {
        return model.type.rawValue + "_brush"
    }

    public var bannerMessage: String {
        if let length = messageMaxLength {
           return model.message.truncateStringIfNeeded(maxLength: length)
        }
        return ""
    }

    public var isActionAvailable: Bool {
        model.hasAction ?? false
    }

    public var isCloseButtonHidden: Bool {
        model.hideCloseButton ?? false
    }

    public var actionButtonLabel: String? {
        model.actionButtonLabel
    }

    public func isTimerRequired() -> Bool {
        model.type == .success || model.type == .information || model.type == .error
    }

    func startTimer() {
        if timer.isValid {
            self.stopTimer()
        }
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) {_ in
            self.elapsedSeconds += 0.01
        }
    }

    func stopTimer() {
        timer.invalidate()
        elapsedSeconds = 0.0
    }

    func getBannerIconSize(size: DynamicTypeSize) -> CGFloat {
        return size < .accessibility2 ? 24 : 48
    }
}
