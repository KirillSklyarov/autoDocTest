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

    func costEstimate() -> Int {
        guard let cgImage = self.cgImage else { return 0 }
        return cgImage.height * cgImage.bytesPerRow
    }
}
