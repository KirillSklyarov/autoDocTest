//
//  AppLabelType.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 23.07.2025.
//


import UIKit

enum AppLabelType {
    case title
    case date
    case category
    case copyLink
    case toastTitle
    case categoryTitle
    case categorySubtitle
}

final class AppLabel: UILabel {

    // MARK: - Init
    init(type: AppLabelType, numberOfLines: Int = 0, title: String? = nil) {
        super.init(frame: .zero)
        configure(type, numberOfLines: numberOfLines, title: title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension AppLabel {
    func configure(_ type: AppLabelType, numberOfLines: Int, title: String?) {
        translatesAutoresizingMaskIntoConstraints = false
        switch type {
        case .title:
            font = .systemFont(ofSize: 18, weight: .bold)
            textColor = .white
            backgroundColor = .clear
            text = title
        case .date:
            font = .systemFont(ofSize: 14, weight: .regular)
            textColor = .gray
            text = title
        case .category:
            font = .systemFont(ofSize: 16, weight: .semibold)
            textColor = .gray
            text = title
        case .copyLink:
            font = .systemFont(ofSize: 16, weight: .semibold)
            textColor = .white
            text = "Скопировать ссылку"
        case .toastTitle:
            font = .systemFont(ofSize: 14, weight: .semibold)
            textColor = .white
            backgroundColor = .clear
            text = title
        case .categoryTitle:
            font = .systemFont(ofSize: 30, weight: .bold)
            textColor = .black
            text = title
        case .categorySubtitle:
            font = .systemFont(ofSize: 30, weight: .regular)
            textColor = .black
            text = title
        }
        self.numberOfLines = numberOfLines

    }
}
