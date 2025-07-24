//
//  AppActivityIndicator.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 24.07.2025.
//


import UIKit

final class AppActivityIndicator: UIActivityIndicatorView {

    override init(style: UIActivityIndicatorView.Style = .large) {
        super.init(style: style)
        color = .systemGreen
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
