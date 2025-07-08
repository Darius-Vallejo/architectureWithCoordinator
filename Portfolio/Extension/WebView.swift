//
//  WebView.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 16/03/25.
//


import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

struct WebViewWithCloseButton: View {
    @Environment(\.presentationMode) var presentationMode
    let url: URL

    var body: some View {
        VStack(spacing: 0) {
            // Header with close button
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.gray)
                }
                .padding()
            }
            Divider()
            // WebView content
            WebView(url: url)
                .edgesIgnoringSafeArea(.bottom)
        }
    }
}
