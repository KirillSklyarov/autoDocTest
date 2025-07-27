//
//  File.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 24.07.2025.
//

import UIKit

extension UIImageView {
    func setImage(from urlString: String, with loader: ImageLoaderProtocol, placeholder: UIImage? = nil, completion: (() -> Void)? = nil) {
        self.image = placeholder

        loader.loadImage(from: urlString) { [weak self] image in
            self?.image = image
            completion?()
        }
    }
}
