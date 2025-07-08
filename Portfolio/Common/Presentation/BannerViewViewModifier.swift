//
//  BannerViewViewModifier.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 23/11/24.
//


import SwiftUI

struct BannerViewViewModifier: ViewModifier {
    private var actionClosure: BannerActionClosure
    private var bannerModel: BannerModel
    private let closeClosure: () -> Void
    private var bgColor: Color
    private var paddingLeading: CGFloat
    private var actionLabel: String
    private var isInAppNotification: Bool
    var isiPad = UIDevice.current.userInterfaceIdiom == .pad
    @Binding public var isShown: Bool
	@AccessibilityFocusState var isFocused: Bool
    init(isShown: Binding<Bool>,
         bannerModel: BannerModel,
         bgColor: Color = .gray,
         actionClosure: @escaping BannerActionClosure,
         closeClosure: @escaping () -> Void,
         paddingLeading: CGFloat = 0.0,
         actionLabel: String = String.empty,
         isInAppNotification: Bool = false) {
        self._isShown = isShown
        self.bannerModel = bannerModel
        self.actionClosure = actionClosure
        self.closeClosure = closeClosure
        self.bgColor = bgColor
        self.paddingLeading = paddingLeading
        self.actionLabel = actionLabel
        self.isInAppNotification = isInAppNotification
    }

    func body(content: Content) -> some View {
        content
            .overlay(isShown && !isInAppNotification ? BannerView(
                viewModel: BannerViewModel(
                    model: bannerModel
                ), isBannerPresent: $isShown,
                actionClosure: {
                    self.actionClosure()
                }, bgColor: bgColor,
                closeClosure: {
                    closeClosure()
                })
                .dynamicTypeSize(.large)
                .padding(.top, 0.2)
                .padding(.leading, paddingLeading)
                .onAppear {
                    focusAfterDelay()
                }
                .transition(.move(edge: .top)) : nil)
    }

    private func focusAfterDelay() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isFocused = true
        }
    }
}

extension View {
    func banner(isShown: Binding<Bool>,
                type: BannerType,
                message: String,
                hasAction: Bool = false,
                hideCloseButton:Bool = false,
                actionClosure: @escaping BannerActionClosure = {},
                closeClosure: @escaping () -> Void = {},
                paddingLeading: CGFloat = 0.0,
                actionLabel: String = String.empty,
                isInAppNotification: Bool = false) -> some View {

        self.modifier(BannerViewViewModifier(
            isShown: isShown,
            bannerModel: BannerModel(type: type, message: message, hasAction: hasAction, hideCloseButton: hideCloseButton),
            bgColor: type.color(),
            actionClosure: actionClosure,
            closeClosure: closeClosure,
            paddingLeading: paddingLeading,
            actionLabel: actionLabel,
            isInAppNotification: isInAppNotification))
    }

    func errorBanner(isShown: Binding<Bool>,
                message: String,
                hasAction: Bool = true,
                hideCloseButton: Bool = false,
                actionClosure: @escaping BannerActionClosure = {},
                closeClosure: @escaping () -> Void = {},
                paddingLeading: CGFloat = 0.0,
                actionLabel: String = String.empty,
                isInAppNotification: Bool = false) -> some View {

        self.modifier(BannerViewViewModifier(
            isShown: isShown,
            bannerModel: BannerModel(type: .error, message: message, hasAction: hasAction, hideCloseButton: hideCloseButton),
            bgColor: BannerType.error.color(),
            actionClosure: actionClosure,
            closeClosure: closeClosure,
            paddingLeading: paddingLeading,
            actionLabel: actionLabel,
            isInAppNotification: isInAppNotification))
    }
}
