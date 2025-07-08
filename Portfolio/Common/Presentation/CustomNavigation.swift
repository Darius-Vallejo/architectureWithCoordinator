//
//  CustomNavigation.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 24/11/24.
//

import SwiftUI
import UIKit

struct CustomNavigation: ViewModifier {
    @Environment(\.dismiss) var dismiss
    let title: String?
    let color: Color
    var onDismiss: (()->Void)?

    init(title: String?, color: Color, onDismiss: (()->Void)? = nil) {
        self.title = title
        self.color = color
        self.onDismiss = onDismiss
    }

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        if let closeAction = onDismiss {
                            closeAction()
                        } else {
                            dismiss()
                        }
                    } label: {
                        Image("backButtonIcon")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(color)
                            .frame(width: 16, height: 16)
                    }
                }

                if let title = self.title {
                    ToolbarItem(placement: .principal) {
                        Text(title)
                            .font(Font.molarumMedium18)
                            .foregroundStyle(Color.blackPortfolio)
                    }
                }
            }
    }
}

struct CustomRightButton: ViewModifier {
    @Environment(\.dismiss) var dismiss
    let title: String?
    let actionBeforeDismiss: (()->Void)?

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if let actionBeforeDismiss = actionBeforeDismiss {
                            actionBeforeDismiss()
                        } else {
                            dismiss()
                        }
                    } label: {
                        Text(title ?? String.localized(.done))
                            .font(Font.molarumMedium18)
                            .foregroundStyle(Color.blackPortfolio)
                    }
                }
            }
    }
}

extension View {
    func addBackButton(andPrincipalTitle title: String? = nil,
                       color: Color = Color.blackPortfolio,
                       isTransparent: Bool = true,
                       onDismiss: (()->Void)? = nil) -> some View {
        setupNavigationBarAppearance(isTransparent: isTransparent)
        return modifier(CustomNavigation(title: title, color: color, onDismiss: onDismiss))
    }

    func addDoneButtonToNavigation(title: String? = nil,
                                   isTransparent: Bool = true,
                                   actionBeforeDismiss: (()->Void)? = nil) -> some View {
        setupNavigationBarAppearance(isTransparent: isTransparent)
        return modifier(CustomRightButton(title: title, actionBeforeDismiss: actionBeforeDismiss))
    }

    func setupNavigationBarAppearance(isTransparent: Bool) {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black, .font: FontUtility.getFontName(.molarum,
                                                                                                          style: .medium)]

        if isTransparent {
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .clear
            appearance.shadowColor = .clear
            appearance.backgroundEffect = nil
            appearance.backButtonAppearance = UIBarButtonItemAppearance(style: .plain)
            appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
            appearance.backButtonAppearance.normal.backgroundImage = nil
        } else {
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = UIColor.white
        }

        UINavigationBar.appearance().tintColor = nil
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
}

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
