//
//  File.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 24.07.2025.
//
import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }

    func resizedMaintainingAspectRatio(to targetSize: CGSize) -> UIImage? {
        let widthRatio  = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height

        let scaleFactor = min(widthRatio, heightRatio)

        let scaledSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 2

        let renderer = UIGraphicsImageRenderer(size: scaledSize, format: format)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: scaledSize))
        }
    }

    func costEstimate() -> Int {
        guard let cgImage = self.cgImage else { return 0 }
        return cgImage.height * cgImage.bytesPerRow
    }
}
