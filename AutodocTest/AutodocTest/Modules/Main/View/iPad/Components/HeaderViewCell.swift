//
//  HeaderViewCell.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 28.07.2025.
//

import UIKit

final class CategoryHeaderView: UIView {

    private lazy var categoryTitle = AppLabel(type: .categoryTitle, title: "Разделы")

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubviews(categoryTitle)
        categoryTitle.setConstraints(insets: UIEdgeInsets(top: 0, left: 10, bottom: 20, right: 0))
    }
}
