//
//  DropdownList.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 16/12/24.
//


import SwiftUI

struct DropdownList: View {
    
    @State private var contentSize: CGFloat = .zero
    @ObservedObject private var viewModel: DropdownViewModel
    var onTapGesture: (()->Void)?

    init(viewModel: DropdownViewModel, onTapGesture: (()->Void)? = nil) {
        _viewModel = .init(wrappedValue: viewModel)
        self.onTapGesture = onTapGesture
    }
    
    var body: some View {
        switch viewModel.state {
        case .success(let items):
            makeOptionsView(with: items)
        case .loading:
            VStack {
                ProgressView("Loading...")
                    .task{
                        await viewModel.viewDidLoad()
                    }
            }.frame(height: 50)
        case .failure(let error):
            Button {
                Task {
                    await viewModel.retry()
                }
            } label: {
                HStack {
                    Text(error)
                        .foregroundColor(.red).padding(.trailing, 10)
                    Image(systemName: "arrow.clockwise")
                }.frame(height: 50)
            }

        }
    }
    
    private func makeOptionsView(with options: [DropdownItem]) -> some View {
        VStack(spacing: 0) {
            // Button-like view for dropdown
            Button(action: {
                onTapGesture?()
                hideKeyboard()
                withAnimation {
                    viewModel.isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(viewModel.componentText)
                        .foregroundColor(!viewModel.isOptionSelected ? .greyPortfolio : .blackPortfolio)

                    Spacer()
                    
                    // Dropdown arrow
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(viewModel.isExpanded ? 180 : 0))
                        .foregroundColor(.black)
                }
                .font(CustomTextFieldConstants.Fonts.textFieldFont)
                .padding(.horizontal, CustomTextFieldConstants.Dimensions.horizontalPadding)
                .padding(.vertical, CustomTextFieldConstants.Dimensions.verticalPadding)
                .background(
                    RoundedRectangle(cornerRadius: CustomTextFieldConstants.Dimensions.cornerRadius)
                        .stroke(CustomTextFieldConstants.Colors.borderColor, lineWidth: CustomTextFieldConstants.Dimensions.borderLineWidth)
                )

            }

            // Dropdown options
            if viewModel.isExpanded {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(options, id: \.self) { option in
                            Button(action: {
                                viewModel.data = option
                                withAnimation {
                                    viewModel.isExpanded = false
                                }
                            }) {
                                HStack {
                                    Text(option.value)
                                        .foregroundColor(.blackPortfolio)
                                        .padding(.vertical, 8)
                                        .font(CustomTextFieldConstants.Fonts.textFieldFont)
                                    Spacer()
                                    if viewModel.isOptionSelected, option == viewModel.data {
                                        Image(systemName: "checkmark")
                                            .tint(.blackPortfolio)
                                    }
                                }
                                .frame(height: 40)
                            }
                            .background(Color.white)
                        }
                        .animation(.none, value: viewModel.data)
                    }
                    .overlay(content: {
                        GeometryReader { proxy in
                            Color.clear.onAppear {
                                contentSize = proxy.size.height
                            }
                        }
                    })
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                }
                .if(contentSize < 40.0*8, transform: {
                    $0.frame(height: contentSize)
                })
                .if(contentSize > 40.0*8, transform: {
                    $0.frame(height: 40.0*8)
                })
            }
        }
    }
}


#Preview {
    DropdownList(
        viewModel: .init(
            placeholder: "Select an item",
            componentName: "Preview Dropdown",
            dataProvider: {
                [
                    .init(id: "1", value: "Option 1", index: 1),
                    .init(id: "2", value: "Option 3", index: 2),
                    .init(id: "3", value: "Option 4", index: 3)
                ]
            })
    )
}
