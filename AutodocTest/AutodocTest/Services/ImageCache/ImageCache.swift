//
//  ImageCache.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 24.07.2025.
//

import UIKit

final class ImageCache {

    // MARK: - Properties
    private let cache = NSCache<NSURL, UIImage>()
    private let fileManager = FileManager.default
    private lazy var cacheDirectoryURL: URL = {
        let caches = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        let url = caches.first!.appending(path: "ImageCache", directoryHint: .isDirectory)
        return url
    }()

    private let oldFilesDaysThreshold = 7

    // MARK: - Init
    init() {
        setupCache()
        createCacheDirectoryIfNeeded()
        clearOldFiles()
    }

    // MARK: - Public methods
    func isImageCached(_ url: URL) -> Bool {
        if cache.object(forKey: url as NSURL) != nil {
            return true
        } else {
            print("Image not found in cache")
        }

        let isExistOnDisk = fileManager.fileExists(atPath: getPath(for: url).path)

        if isExistOnDisk {
            print("Image found on disk")
            saveImageFromDiskToCache(url)
        } else {
            print("Image not found on disk")
        }

        return isExistOnDisk
    }

    func getImageFromCache(_ url: URL) -> UIImage? {
        if let image = cache.object(forKey: url as NSURL) {
            return image
        }

        saveImageFromDiskToCache(url)
        let image = cache.object(forKey: url as NSURL)
        return image
    }

    func saveImageToCache(_ image: UIImage?, _ url: URL, isExistOnDisk: Bool = false) {
        let resizedImage: UIImage
        if isExistOnDisk {
            guard let tempImage = getImageFromDisk(url) else { return }
            resizedImage = tempImage
        } else {
            guard let tempImage = getResizedImage(image) else { return }
            resizedImage = tempImage
            saveImageToDisk(resizedImage, url)
        }

        let cost = resizedImage.costEstimate()
        print(cost)
        cache.setObject(resizedImage, forKey: url as NSURL, cost: cost)
        print("✅ saved to cache")
    }

    func clearCache() {
        cache.removeAllObjects()
        try? fileManager.removeItem(at: cacheDirectoryURL)
    }
}

// MARK: - Supporting methods
private extension ImageCache {
    func setupCache() {
        cache.totalCostLimit = 30 * 1024 * 1024
        cache.countLimit = 30
    }

    func getResizedImage(_ image: UIImage?) -> UIImage? {
        guard let image else { print("image is nil"); return nil }
        let screenWidth = UIScreen.main.bounds.width
        let aspectRatio: CGFloat = 1000 / 1600
        let size = CGSize(width: screenWidth, height: screenWidth * aspectRatio)

        return image.resizedMaintainingAspectRatio(to: size)
    }

    func saveImageFromDiskToCache(_ url: URL) {
        let image = getImageFromDisk(url)
        saveImageToCache(image, url, isExistOnDisk: true)
    }

    func createCacheDirectoryIfNeeded() {
        if !fileManager.fileExists(atPath: cacheDirectoryURL.path) {
            do {
                try fileManager.createDirectory(at: cacheDirectoryURL, withIntermediateDirectories: true)
                print("✅ cache directory created")
            } catch {
                print("🔴 failed to create directory: \(error)")
            }
        } else {
            print("✅ Cache directory already exists")
        }
    }

    func saveImageToDisk(_ image: UIImage, _ url: URL) {
        print(image.size)
        let fileURL = getPath(for: url)
        guard let data = image.jpegData(compressionQuality: 0.6) else {
            print("🔴 Failed to convert image to JPEG data")
            return }
        do {
            try data.write(to: fileURL)
            print("✅ saved to disk")
        } catch {
            print("🔴 image NOT saved to disk: \(error.localizedDescription)")
        }
    }

    func getImageFromDisk(_ url: URL) -> UIImage? {
        let fileURL = getPath(for: url)
        guard let data = try? Data(contentsOf: fileURL) else { print("🔴 Image NOT loaded from disk"); return nil }
        print("✅ Image loaded from disk")
        return UIImage(data: data)
    }

    func getPath(for url: URL) -> URL {
        let filename = String(url.lastPathComponent)
        return cacheDirectoryURL.appendingPathComponent(filename)
    }

    func clearOldFiles() {
        let expirationDate = Date().addingTimeInterval(TimeInterval(-oldFilesDaysThreshold * 24 * 60 * 60))

        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: cacheDirectoryURL, includingPropertiesForKeys: [.contentModificationDateKey])
            for fileURL in fileURLs {
                let attributes = try fileURL.resourceValues(forKeys: [.contentModificationDateKey])
                if let modifiedDate = attributes.contentModificationDate, modifiedDate < expirationDate {
                    try fileManager.removeItem(at: fileURL)
                    print("🗑 Removed old cached file: \(fileURL.lastPathComponent)")
                }
            }
        } catch {
            print("🔴 Failed to clear old cached files: \(error.localizedDescription)")
        }
    }
}
