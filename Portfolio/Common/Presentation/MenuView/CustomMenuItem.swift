//
//  CustomMenuItem.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 21/01/25.
//

import Foundation
import SwiftUI

struct CustomMenuItem: Identifiable {
    let id = UUID()
    var title: String?
    var image: String?
    let textColor: Color
    let action: () -> Void
}
