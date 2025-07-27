//
//  AppImageViewType.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 23.07.2025.
//

import UIKit

enum AppImageViewType {
    case newsImage
    case dotsImage
    case checkmark
}

final class AppImageView: UIImageView {

    // MARK: - Init
    init(type: AppImageViewType) {
        super.init(frame: .zero)
        configure(type)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setImage(_ image: UIImage?) {
        self.image = image
    }
}

// MARK: - Setup UI
private extension AppImageView {
    func configure(_ type: AppImageViewType) {
        switch type {
        case .newsImage:
            translatesAutoresizingMaskIntoConstraints = false
        case .dotsImage:
            image = UIImage(systemName: "ellipsis")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        case .checkmark:
            let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)
            image = UIImage(systemName: "checkmark", withConfiguration: config)?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        }
    }
}
