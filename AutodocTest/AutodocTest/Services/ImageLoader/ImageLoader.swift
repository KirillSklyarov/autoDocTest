//
//  ImageLoader.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 24.07.2025.
//

import UIKit

protocol ImageLoaderProtocol {
    func getImageFromCache(_ url: String) -> UIImage?
    func downloadImageAndSaveToCache(from url: String) async throws
}

final class ImageLoader: ImageLoaderProtocol {

    private let imageCache: ImageCache
    private let session: URLSession

    init(imageCache: ImageCache, session: URLSession) {
        self.imageCache = imageCache
        self.session = session
    }

    func getImageFromCache(_ url: String) -> UIImage? {
        guard let url = URL(string: url) else { Log.imageLoader.errorAlways("Invalid URL"); return nil }
        return imageCache.getImageFromCache(url)
    }

    func downloadImageAndSaveToCache(from url: String) async throws {
        var data: (image: UIImage, url: URL)?
        do {
            data = try await downloadImage(from: url)
            saveToCache(with: data)
        } catch {
            throw NetworkError.unknown(error)
        }
    }
}

// MARK: - Supporting methods
private extension ImageLoader {
     func downloadImage(from urlString: String) async throws -> (UIImage, URL)? {

         guard let url = URL(string: urlString) else { Log.imageLoader.errorAlways("Invalid URL")
             throw NetworkError.invalidURL
         }

        if imageCache.isImageCached(url) {
            Log.imageLoader.debugOnly("Already cached or found on disk")
            return nil
        } else {
            Log.imageLoader.debugOnly("Downloading image and saving to cache")
        }

        let (data, _) = try await session.data(from: url)

         guard let image = UIImage(data: data) else { Log.imageLoader.errorAlways("Failed to create image from data")
             return nil
         }

        return (image, url)
    }

    func saveToCache(with data: (image: UIImage, url: URL)?) {
        guard let data else { return }
        imageCache.saveImageToCache(data.image, data.url)
    }
}
