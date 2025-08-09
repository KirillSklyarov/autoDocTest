//
//  ImageDownsampler.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 09.08.2025.
//

import UIKit

protocol ImageDownsampling {
    func downsampleImage(data: Data) -> UIImage?
}

final class ImageDownsampler: ImageDownsampling {

    private let aspectRatio: CGFloat = 1000 / 1600
    private let scale: CGFloat = 2

    init() { }

    func downsampleImage(data: Data) -> UIImage? {

        let imageSize = getCorrectImageSize()

        let options: [CFString: Any] = [
            kCGImageSourceShouldCache: false,
            kCGImageSourceShouldCacheImmediately: false
        ]

        guard let src = CGImageSourceCreateWithData(data as CFData, options as CFDictionary) else { return nil }

        let maxDimensionInPixels = max(imageSize.width, imageSize.height) * scale

        let downsampleOptions: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels.rounded(.up),
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true
        ]

        guard let cgThumb = CGImageSourceCreateThumbnailAtIndex(src, 0, downsampleOptions as CFDictionary) else {
            return nil
        }
        return UIImage(cgImage: cgThumb, scale: scale, orientation: .up)
    }

    private func getCorrectImageSize() -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let size = CGSize(width: screenWidth, height: screenWidth * aspectRatio)
        return size
    }
}


