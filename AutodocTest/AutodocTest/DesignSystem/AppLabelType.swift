//
//  AppLabelType.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 23.07.2025.
//


import UIKit

enum AppLabelType {
    case title
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
        switch type {
        case .title:
            font = .systemFont(ofSize: 16, weight: .bold)
            textColor = .black
            backgroundColor = .clear
            text = title
            self.numberOfLines = numberOfLines
        }
    }
}
