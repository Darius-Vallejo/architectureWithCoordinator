//
//  NavigationAdapterForSettings.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 26/11/24.
//

import SwiftUI

class ModalAdapter<Modal>: ObservableObject where Modal: Identifiable {
    @Published var presentModal: Modal?
}
