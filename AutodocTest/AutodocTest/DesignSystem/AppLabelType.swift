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
            self.numberOfLines = numberOfLines
        case .date:
            font = .systemFont(ofSize: 14, weight: .regular)
            textColor = .gray
            text = title
            self.numberOfLines = numberOfLines
        case .category:
            font = .systemFont(ofSize: 16, weight: .semibold)
            textColor = .gray
            text = title
            self.numberOfLines = numberOfLines
        }
    }
}
