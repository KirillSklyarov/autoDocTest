//
//  ImageLoader.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 24.07.2025.
//

import UIKit

protocol ImageLoaderProtocol {
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void)
    func loadImageToCache(from urlString: String) async throws
}


final class ImageLoader: ImageLoaderProtocol {

    private let imageCache: ImageCache
    private let session: URLSession

    init(imageCache: ImageCache, session: URLSession) {
        self.imageCache = imageCache
        self.session = session
    }

    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else { completion(nil);
            print("Invalid URL"); return }

//        print(#function, imageCache.isImageCached(url))
        if imageCache.isImageCached(url) {
            let image = imageCache.getImageFromCache(url)
//            print("✅ Get image from cache")
            completion(image)
            return
        }

        session.dataTask(with: url) { [weak self] data, _, error in
            guard let self, let data, error == nil, let image = UIImage(data: data)
            else { return }

            print("🔴 Downloading image and saving to cache")
            imageCache.saveImageToCache(image, url)

            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }

    func loadImageToCache(from urlString: String) async throws {

        guard let url = URL(string: urlString) else { print("Invalid URL"); throw NetworkError.invalidURL }

        if imageCache.isImageCached(url) {
            print("Already cached or found on disk");
            return
        } else {
            print("Downloading image and saving to cache")
        }

        let (data, _) = try await session.data(from: url)

        guard let image = UIImage(data: data) else { print("Failed to create image from data"); return }

        imageCache.saveImageToCache(image, url)
    }
}
