//
//  AppButtonType.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 27.07.2025.
//


import UIKit

enum AppButtonType {
    case share
    case dismiss
    case shareNews
    case copyLink
}

final class AppButtons: UIButton {

    var onButtonTapped: (() -> Void)?

    init(type: AppButtonType, text: String? = nil) {
        super.init(frame: .zero)
        configureLabel(type: type, text: text)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AppButtons {
    func configureLabel(type: AppButtonType, text: String?) {
        switch type {
        case .share:
            let image = UIImage(systemName: "ellipsis.circle.fill")?.withTintColor(.darkGray, renderingMode: .alwaysOriginal)
            contentHorizontalAlignment = .fill
            contentVerticalAlignment = .fill
            setImage(image, for: .normal)
            heightAnchor.constraint(equalToConstant: 30).isActive = true
            widthAnchor.constraint(equalToConstant: 30).isActive = true
        case .dismiss:
            let attributedTitle = NSAttributedString(string: "Отмена", attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 20, weight: .semibold)])
            setAttributedTitle(attributedTitle, for: .normal)
        case .shareNews:
            let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
            let image = UIImage(systemName: "square.and.arrow.up", withConfiguration: config)?.withTintColor(.white, renderingMode: .alwaysOriginal)
            contentHorizontalAlignment = .center
            contentVerticalAlignment = .center
            setImage(image, for: .normal)
        case .copyLink:
            let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
            let image = UIImage(systemName: "document.on.document", withConfiguration: config)?.withTintColor(.white, renderingMode: .alwaysOriginal)
            contentHorizontalAlignment = .center
            contentVerticalAlignment = .center
            setImage(image, for: .normal)
        }
    }
}
