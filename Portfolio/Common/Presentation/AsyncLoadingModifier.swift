//
//  AsyncLoadingModifier.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 24/12/24.
//

import SwiftUI

struct AsyncLoadingModifier: ViewModifier {
    @Binding var isPresented: Bool
    var message: String = "Loading, please wait..."
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isPresented) // Disable interaction with the underlying view
                .blur(radius: isPresented ? 3 : 0) // Optional blur effect for the background
            
            if isPresented {
                // Dimmed overlay with loader and message
                ZStack {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text(message)
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.8))
                    )
                }
                .transition(.opacity) // Fade in/out
            }
        }
        .animation(.easeInOut, value: isPresented)
    }
}
