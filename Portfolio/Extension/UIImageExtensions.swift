//
//  UIImageExtensions.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 12/12/24.
//

import UIKit

extension UIImage {
    func compress(to maxFileSize: Int = 9 * 1024 * 1024, compressionQuality: CGFloat = 0.6) -> Data? {
        var compression = compressionQuality
        guard var data = jpegData(compressionQuality: compression) else { return nil }

        while data.count > maxFileSize && compression > 0 {
            compression -= 0.1
            if let compressedData = jpegData(compressionQuality: compression) {
                data = compressedData
            } else {
                return nil
            }
        }

        return data.count <= maxFileSize ? data : nil
    }
}
