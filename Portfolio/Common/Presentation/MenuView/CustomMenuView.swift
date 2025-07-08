//
//  CustomMenuView.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 21/01/25.
//


import SwiftUI

struct CustomMenuView: View {
    // Whether the menu is currently shown
    @Binding var isShown: Bool

    // Tapping outside the menu
    var onTapOutside: (() -> Void)? = nil

    // The position where the menu should appear
    let position: CGPoint

    // Array of items in the menu
    let items: [CustomMenuItem]

    // Styling
    let backgroundOpacity: Double
    let menuWidth: CGFloat
    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
    var shouldCloseOnTap: Bool = true
    var maxHeight: CGFloat? = nil

    var body: some View {
        if isShown {
            ZStack {
                // 1) Dark background overlay
                Color.black.opacity(backgroundOpacity)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShown = false
                        onTapOutside?()
                    }

            itemsVStack
                .padding(8)
                .background(Color.white)
                .cornerRadius(cornerRadius)
                .shadow(radius: shadowRadius)
                .frame(width: menuWidth)
                .position(position)
            }
            .ignoresSafeArea()
        }
    }

    @ViewBuilder
    private var itemsVStack: some View {
        if maxHeight == nil {
            VStack(alignment: .leading, spacing: 5) {
                ForEach(items) { item in
                    menuItem(item: item)
                }
            }
        } else {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(items) { item in
                        menuItem(item: item)
                    }
                }
            }
            .frame(maxHeight: maxHeight ?? 0)
        }
    }

    // Single menu item row
    func menuItem(item: CustomMenuItem) -> some View {
        Button {
            // Hide the menu before performing the action
            if shouldCloseOnTap {
                isShown = false
            }
            item.action()
        } label: {
            HStack(spacing: 8) {
                if let image = item.image {
                    if item.title == nil {
                        Spacer()
                    }
                    Image(image)
                        .renderingMode(.template)
                        .foregroundColor(item.textColor)
                        .frame(width: 16, height: 16)
                    if item.title == nil {
                        Spacer()
                    }
                }
                if let title = item.title {
                    Text(title)
                        .font(.interDisplayRegular14)
                        .foregroundColor(item.textColor)
                    Spacer()
                }
            }
            .padding(8)
        }
    }
}

struct CustomMenuView_Previews: PreviewProvider {
    @State static var isShown = true

    static var previews: some View {
        CustomMenuView(
            isShown: $isShown,
            onTapOutside: {},
            position: CGPoint(x: 200, y: 200),
            items: [
                CustomMenuItem(
                    title: "Edit",
                    image: "editAttachmentIcon",
                    textColor: .black,
                    action: { print("Edit tapped") }
                ),
                CustomMenuItem(
                    title: "Delete",
                    image: "deleteAttachmentIcon",
                    textColor: .red,
                    action: { print("Delete tapped") }
                )
            ],
            backgroundOpacity: 0.1,
            menuWidth: 130,
            cornerRadius: 12,
            shadowRadius: 1
        )
    }
}
