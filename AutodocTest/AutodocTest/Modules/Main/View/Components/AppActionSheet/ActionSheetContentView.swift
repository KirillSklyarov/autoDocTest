//
//  ActionSheetContentview.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 27.07.2025.
//

import UIKit

final class ActionSheetContentView: UIView {

    // MARK: - Properties
    private lazy var blurView = AppBlurView()
    private lazy var titleLabel = AppLabel(type: .title)
    private lazy var dateLabel = AppLabel(type: .date)
    private lazy var shareButton = AppButtons(type: .shareNews)
    private lazy var copyLinkButtonView = CopyLinkButtonView()

    private lazy var contentStackView = setupContentStack()

    private let viewHeight: CGFloat = 120

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureUI(with data: News) {
        titleLabel.text = data.title
        dateLabel.text = data.publishedDate
    }
}

// MARK: - Supporting methods
private extension ActionSheetContentView {
    func setupContentStack() -> AppStackView {
       let textStackView = AppStackView([titleLabel, dateLabel, UIView()], axis: .vertical)

        let tempStackView = AppStackView([textStackView, UIView(), shareButton], axis: .horizontal)

        let contentStackView = AppStackView([tempStackView, copyLinkButtonView], axis: .vertical, spacing: 5)
        return contentStackView
    }


    func setupUI() {
        layer.cornerRadius = 10
        clipsToBounds = true

        addSubviews(blurView, contentStackView)
        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            heightAnchor.constraint(equalToConstant: viewHeight)
        ])

        blurView.setConstraints()
    }

    func setupAction() {
        copyLinkButtonView.onCopyLinkTapped = { [weak self] in
            print(#function)
        }
    }
}
