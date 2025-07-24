//
//  ImageCache.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 24.07.2025.
//

import UIKit

final class ImageCache {

    private var cache = NSCache<NSURL, UIImage>()

    func isImageCached(_ url: URL) -> Bool {
        cache.object(forKey: url as NSURL) != nil
    }

    func getImageFromCache(_ url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }

    func saveImageToCache(_ image: UIImage?, _ url: URL) {
        guard let resizedImage = getResizedImage(image) else { return }
        print("✅ saved to cache")
        cache.setObject(resizedImage, forKey: url as NSURL)
    }

    func clearCache() {
        cache.removeAllObjects()
    }
}

private extension ImageCache {
    func getResizedImage(_ image: UIImage?) -> UIImage? {
        guard let image else { print("image is nil"); return nil }
        let scale = UIScreen.main.scale
        let size = CGSize(width: 80 * scale, height: 80 * scale)
        return image.resizedMaintainingAspectRatio(to: size)
    }
}
