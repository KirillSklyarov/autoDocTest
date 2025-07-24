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
        guard let image else { return }
        cache.setObject(image, forKey: url as NSURL)
    }

    func clearCache() {
        cache.removeAllObjects()
    }
}
