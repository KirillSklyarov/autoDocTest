//
//  AppImageViewType.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 23.07.2025.
//

import UIKit

enum AppImageViewType {
    case newsImage
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

//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.layer.cornerRadius = frame.height / 2
//    }
}

// MARK: - Setup UI
private extension AppImageView {
    func configure(_ type: AppImageViewType) {
        switch type {
        case .newsImage:
//            clipsToBounds = true
//            contentMode = .scaleAspectFill
            translatesAutoresizingMaskIntoConstraints = false
//            heightAnchor.constraint(equalToConstant: 80).isActive = true
//            widthAnchor.constraint(equalToConstant: 80).isActive = true
//            backgroundColor = .black
        }
    }
}
