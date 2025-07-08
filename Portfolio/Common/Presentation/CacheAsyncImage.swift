//
//  CacheAsyncImage.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 12/12/24.
//


import SwiftUI
import AlamofireImage
import Alamofire

struct CacheAsyncImage: View {
    @State private var image: SwiftUI.Image? = nil
    @State private var isLoading: Bool = false
    @State var urlString: String
    let colorForFilling: Color
    let contentMode: ContentMode

    init(image: SwiftUI.Image? = nil,
         urlString: String,
         colorForFilling: Color = .gray,
         contentMode: ContentMode = .fit,
         isPreloading: Bool = false) {
        self.image = image
        self.urlString = urlString
        self.colorForFilling = colorForFilling
        self.contentMode = contentMode
        if isPreloading {
            preload()
        }
    }

    var body: some View {
        VStack {
            if let image = image {
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else {
                ZStack {
                    Rectangle()
                        .fill(colorForFilling)
                    if isLoading {
                        ProgressView()
                    }
                }
                .onAppear {
                    preload()
                }
                .onChange(of: urlString) { _, newUrl in
                    downloadImage(from: newUrl)
                }
            }
        }
    }

    func preload() {
        downloadImage(from: urlString)
    }

    func downloadImage(from url: String) {
        //isLoading = true
        if let imageUrl = URL(string: url) {
            AF.request(imageUrl).responseImage { response in
                isLoading = false
                if case .success(let image) = response.result {
                    DispatchQueue.main.async {
                        self.image = Image(uiImage: image)
                    }
                } else if case .failure(let error) = response.result {
                    print("Error fetching image: \(error)")

                }
            }
        }
    }
}

