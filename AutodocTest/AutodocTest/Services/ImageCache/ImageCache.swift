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
            Log.cache.debugOnly("Image not found in cache")
        }

        let isExistOnDisk = fileManager.fileExists(atPath: getPath(for: url).path)

        if isExistOnDisk {
            Log.cache.debugOnly("Image found on disk")
            saveImageFromDiskToCache(url)
        } else {
            Log.cache.debugOnly("Image not found on disk")
        }

        return isExistOnDisk
    }

    func getImageFromCache(_ url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
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
        cache.setObject(resizedImage, forKey: url as NSURL, cost: cost)
        Log.cache.debugOnly("Image saved to cache")
    }

    func clearCache() {
        Log.cache.debugOnly("Cache cleared")
        cache.removeAllObjects()
        clearCacheDirectory()
    }
}

// MARK: - Supporting methods
private extension ImageCache {
    func setupCache() {
        cache.totalCostLimit = 30 * 1024 * 1024
        cache.countLimit = 30
    }

    func getResizedImage(_ image: UIImage?) -> UIImage? {
        guard let image else {
            Log.cache.errorAlways("Image is nil")
            return nil

        }
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
                Log.cache.debugOnly("Cache directory created \(self.cacheDirectoryURL.path)")
            } catch {
                Log.cache.errorAlways("Failed to create cache directory: \(error)")
            }
        } else {
            Log.cache.debugOnly("Cache directory already exists \(self.cacheDirectoryURL.path)")
        }
    }

    func saveImageToDisk(_ image: UIImage, _ url: URL) {
        let fileURL = getPath(for: url)
        guard let data = image.jpegData(compressionQuality: 0.6) else {
            Log.cache.errorAlways("Failed to convert image to JPEG data")
            return }
        do {
            try data.write(to: fileURL)
            Log.cache.debugOnly("Image saved to disk \(fileURL.path)")
        } catch {
            Log.cache.debugOnly("Image NOT saved to disk: \(error.localizedDescription)")
        }
    }

    func getImageFromDisk(_ url: URL) -> UIImage? {
        let fileURL = getPath(for: url)
        guard let data = try? Data(contentsOf: fileURL) else {
            Log.cache.debugOnly("Image NOT loaded from disk")
            return nil
        }
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
                    Log.cache.debugOnly("Removed old cached file: \(fileURL.lastPathComponent)")
                }
            }
        } catch {
            Log.cache.errorAlways("Failed to clear old cached files: \(error.localizedDescription)")
        }
    }

    func clearCacheDirectory() {
        do {
            let fileUrls = try fileManager.contentsOfDirectory(at: cacheDirectoryURL, includingPropertiesForKeys: nil, options: [])
            try fileUrls.forEach { try fileManager.removeItem(at: $0) }
        } catch {
            Log.cache.errorAlways("Failed to clear cache without removing directory: \(error.localizedDescription)")
        }
    }
}
