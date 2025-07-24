//
//  File.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 24.07.2025.
//

import UIKit

extension UIImageView {
    func loadImage(from urlString: String, placeholder: UIImage? = nil) {
        self.image = placeholder

        guard let url = URL(string: urlString) else { print("Invalid URL"); return }

        // Чтобы избежать гонок при переиспользовании ячеек
//        let currentTag = self.tag + 1
//        self.tag = currentTag

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self, let data, error == nil, let image = UIImage(data: data)
            else { return }

            DispatchQueue.main.async {
//                guard self.tag == currentTag else { return }
                self.image = image
            }
        }.resume()
    }
}
