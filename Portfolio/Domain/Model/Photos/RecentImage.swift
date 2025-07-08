//
//  RecentImage.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 28/11/24.
//

import UIKit

struct RecentImage {
    let id = UUID() // Unique identifier
    let thumbnail: UIImage
    let fullImage: UIImage?
}

extension RecentImage: Equatable {
    
    func compressThumbnailImage() -> Data? {
        return thumbnail.compress()
    }
    
}
