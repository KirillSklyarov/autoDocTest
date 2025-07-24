//
//  ImageLoader.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 24.07.2025.
//

import UIKit


final class ImageLoader {

    private let imageCache: ImageCache
    private let session: URLSession


    init(imageCache: ImageCache, session: URLSession) {
        self.imageCache = imageCache
        self.session = session
    }

    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
//        self.image = placeholder

        guard let url = URL(string: urlString) else { completion(nil);
            print("Invalid URL"); return }

        if imageCache.isImageCached(url) {
            let image = imageCache.getImageFromCache(url)
            completion(image)
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self, let data, error == nil, let image = UIImage(data: data)
            else { return }

            imageCache.saveImageToCache(image, url)

            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}

