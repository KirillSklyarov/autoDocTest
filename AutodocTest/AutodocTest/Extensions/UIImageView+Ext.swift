//
//  File.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 24.07.2025.
//

import UIKit

extension UIImageView {
    func setImage(from urlString: String, with loader: ImageLoaderProtocol, completion: (() -> Void)? = nil) {
        self.image = loader.getImageFromCache(urlString)
    }
}
