//
//  CopyLinkButtonView.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 27.07.2025.
//

import UIKit

final class CopyLinkButtonView: UIButton {

    // MARK: - Properties
    private lazy var roundView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 8
        return view
    }()
    private lazy var copyTitle = AppLabel(type: .copyLink)
    private lazy var copyImageView = AppButtons(type: .copyLink)

    private lazy var contentStack = AppStackView([copyTitle, UIView(), copyImageView], axis: .horizontal)

    private let height: CGFloat = 50

    var onCopyLinkTapped: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupTapGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CopyLinkButtonView {
    func setupUI() {
        roundView.addSubviews(contentStack)
        contentStack.setConstraints(insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))

        addSubviews(roundView)
        roundView.setConstraints()

        heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        addGestureRecognizer(tapGesture)
    }

    @objc func buttonTapped() {
        onCopyLinkTapped?()
    }
}
