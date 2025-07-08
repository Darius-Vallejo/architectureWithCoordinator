//
//  SettingRow.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 25/11/24.
//

import SwiftUI

struct SettingRow: View {
    var iconName: String
    var iconColor: Color = SettingRowConstants.Colors.iconForegroundColor
    var iconForegroundColor: Color = SettingRowConstants.Colors.iconForegroundColor
    var opacity: CGFloat = SettingRowConstants.Colors.iconBackgroundOpacity
    var title: String
    var titleColor: Color = SettingRowConstants.Colors.titleColor
    var showTrailingImage: Bool = true

    var body: some View {
        HStack {
            Circle()
                .fill(iconColor.opacity(opacity))
                .frame(width: SettingRowConstants.Dimensions.iconBackgroundSize,
                       height: SettingRowConstants.Dimensions.iconBackgroundSize)
                .overlay(
                    Image(iconName)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(iconForegroundColor)
                        .frame(width: SettingRowConstants.Dimensions.iconSize,
                               height: SettingRowConstants.Dimensions.iconSize)
                )

            Text(title)
                .font(SettingRowConstants.Fonts.titleFont)
                .foregroundColor(titleColor)
                .padding(.vertical, SettingRowConstants.Dimensions.titleVerticalPadding)

            Spacer()

            if showTrailingImage {
                Image(SettingRowConstants.Assets.goNext)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: SettingRowConstants.Dimensions.nextIconSize,
                           height: SettingRowConstants.Dimensions.nextIconSize)
                    .foregroundColor(SettingRowConstants.Colors.nextIconColor)
            }
        }
        .padding(.horizontal, SettingRowConstants.Dimensions.horizontalPadding)
        .frame(height: SettingRowConstants.Dimensions.rowHeight)
    }
}

#Preview {
    SettingRow(iconName: "yourIconName", iconColor: .yellowPortfolio, title: "Your Title")
}
