//
//  ImageHelper.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import UIKit

// Profilbild klein machen, damit es als Base64 in Firestore passt
enum ImageHelper {
    static func compressedJpeg(from data: Data, maxSize: CGFloat = 256, quality: CGFloat = 0.8) -> Data? {
        guard let image = UIImage(data: data) else { return nil }
        let scale = min(1, maxSize / max(image.size.width, image.size.height))
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let resized = UIGraphicsImageRenderer(size: size, format: format).image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        return resized.jpegData(compressionQuality: quality)
    }
}
