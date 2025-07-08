//
//  ContentView.swift
//  portfolio
//
//  Created by Dario Fernando Vallejo Posada on 13/11/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    private let coordinator: AppCoordinatorProtocol
    
    init(coordinator: AppCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    var body: some View {
        coordinator.makeLoginFlow()
    }
}

#Preview {
    ContentView(coordinator: AppCoordinatorFactory.create())
}
