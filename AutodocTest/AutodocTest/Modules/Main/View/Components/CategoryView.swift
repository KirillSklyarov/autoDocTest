//
//  CategoryView.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 26.07.2025.
//

import UIKit

final class CategoryView: UIView {

    private let viewHeight: CGFloat = 40

    private lazy var radiusView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        view.setBorder(.gray, borderWidth: 1)
        return view
    }()
    private lazy var categoryLabel = AppLabel(type: .category)

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setText(_ text: String) {
        categoryLabel.text = text
    }
}

private extension CategoryView {
    func setupUI() {
        radiusView.addSubviews(categoryLabel)
        addSubviews(radiusView)
        setupLayout()
    }

    func setupLayout() {
        categoryLabel.setLocalConstraints(top: 5, bottom: 5, left: 10)
        radiusView.setLocalConstraints(top: 5, bottom: 5, left: 20)

        NSLayoutConstraint.activate([
            radiusView.trailingAnchor.constraint(equalTo: categoryLabel.trailingAnchor, constant: 10),
            heightAnchor.constraint(equalToConstant: viewHeight)
        ])
    }
}
