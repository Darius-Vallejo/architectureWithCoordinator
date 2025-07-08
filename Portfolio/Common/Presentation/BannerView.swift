//
//  BannerView.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 23/11/24.
//


import SwiftUI


public typealias BannerActionClosure = () -> Void

public struct BannerView: View {
    public var actionClosure: BannerActionClosure
    public var interval: Double { 5.0 - self.viewModel.elapsedSeconds }
    @StateObject public var viewModel: BannerViewModel
    @Binding public var isBannerPresent: Bool
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.dynamicTypeSize) var size
    private let closeClosure: () -> Void
    public var bgColor: Color
    private var isiPad: Bool {
        return horizontalSizeClass == .regular
    }
    public struct Constants {
        public static let defaultBackgroundColor = Color.gray
    }

    public init(viewModel: BannerViewModel,
                isBannerPresent: Binding<Bool>,
                actionClosure: @escaping BannerActionClosure,
                bgColor: Color = Constants.defaultBackgroundColor,
                closeClosure: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self._isBannerPresent = isBannerPresent
        self.actionClosure = actionClosure
        self.bgColor = bgColor
        self.closeClosure = closeClosure
    }

    public var body: some View {
        VStack {
            ZStack(alignment: .top) {
                bgColor
                    .ignoresSafeArea()
                VStack {
                    VStack(alignment: .center, spacing: 8) {
                        HStack(alignment: .center, spacing: 16) {
                            VStack {
                                HStack {
                                    VStack(alignment: .center) {
                                        Image(viewModel.bannerIconName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: viewModel.getBannerIconSize(size: size),
                                                   height: viewModel.getBannerIconSize(size: size))
                                            .padding(.vertical, 20)
                                    }
                                    Text(viewModel.bannerMessage)
                                        .font(.newBlackTypefaceRegular16)
                                        .foregroundColor(.blackPortfolio)
                                        .lineLimit((size < .xLarge) ? 3 : nil)
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                }
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            .accessibilityElement(children: .combine)
                            .accessibilitySortPriority(2)
                            if viewModel.isActionAvailable {
                                Button(action: {
                                    actionClosure()
                                }) {
                                    Text(viewModel.actionButtonLabel ?? "")
                                        .font(.newBlackTypefaceRegular16)
                                        .bold()
                                        .underline()
                                        .foregroundColor(.blackPortfolio)
                                }
                            }
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(Color.blackPortfolio)
                                    .frame(width: 20, height: 20)
                                    .frame(width: viewModel.getBannerIconSize(size: size),
                                           height: viewModel.getBannerIconSize(size: size))
                            }
                            .if(viewModel.isCloseButtonHidden, transform: { view in
                                view.hidden()
                            })
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, .zero)
                        .frame(maxWidth: isiPad ? 620 : .infinity, alignment: .leading)
                    }
                    .frame(alignment: .center)
                    .background(
                        VStack {
                            Spacer()
                            Image(viewModel.bannerBrushImageName)
                                .resizable()
                                .frame(maxWidth: isiPad ? 640 : .infinity, maxHeight: 2)
                                .frame(maxWidth: isiPad ? 640 : .infinity, maxHeight: 2)
                        }
                    )
                }
                .onReceive(viewModel.$elapsedSeconds) { _ in
                    if self.interval <= 0 {
                        dismiss()
                    }
                }
            }
            .frame(
                maxWidth: isiPad ? 640 : .infinity,
                maxHeight: UIScreen.main.bounds.height * (size < .xLarge ? 0.07 : 1)
            )
            .if(viewModel.isCloseButtonHidden, transform: {
                $0.fixedSize(horizontal: false, vertical: true)
            })
            .onAppear(perform: {
                if viewModel.isTimerRequired() {
                    if !UIAccessibility.isVoiceOverRunning {
                        self.viewModel.startTimer()
                    }
                }
            })
            if !viewModel.isCloseButtonHidden {
                Spacer()
            }
        }
    }

    private func dismiss() {
        withAnimation {
            self.viewModel.stopTimer()
            isBannerPresent = false
            closeClosure()
        }
    }
}

public struct BannerView_Previews: PreviewProvider {
    public static var previews: some View {
        BannerView(
            viewModel: BannerViewModel(
                model: BannerModel(type: .information, message: "The info text used in the alerts should be two lines maximum.", hasAction: true)
            ), isBannerPresent: .constant(true), actionClosure: {}, closeClosure: {}
        )
    }
}
