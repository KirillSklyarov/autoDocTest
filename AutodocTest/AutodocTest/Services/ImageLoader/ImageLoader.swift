//
//  ImageLoader.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 24.07.2025.
//

import UIKit
import ImageIO

protocol ImageLoaderProtocol {
    func getImageFromCache(_ url: String) -> UIImage?
    func downloadImageAndSaveToCache(from url: String) async throws
}

final class ImageLoader: ImageLoaderProtocol {

    private let imageCache: ImageCache
    private let imageDownsampler: ImageDownsampling
    private let session: URLSession

    init(imageCache: ImageCache, imageDownsampler: ImageDownsampling, session: URLSession) {
        self.imageCache = imageCache
        self.imageDownsampler = imageDownsampler
        self.session = session
    }

    // MARK: - Public methods
    func getImageFromCache(_ url: String) -> UIImage? {
        guard let url = URL(string: url) else { Log.imageLoader.errorAlways("Invalid URL"); return nil }
        return imageCache.getImageFromCache(url)
    }

    func downloadImageAndSaveToCache(from url: String) async throws {
        var data: (data: Data, url: URL)?
        do {
            data = try await downloadImage(from: url)
            guard let data,
                  let image = imageDownsampler.downsampleImage(data: data.data) else { return }
            saveToCache(with: image, url: data.url)
        } catch {
            throw NetworkError.unknown(error)
        }
    }
}

// MARK: - Supporting methods
private extension ImageLoader {
     func downloadImage(from urlString: String) async throws -> (Data, URL)? {

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
         
        return (data, url)
    }

    func saveToCache(with image: UIImage, url: URL) {
        imageCache.saveImageToCache(image, url)
    }
}
