//
//  ImageTitleCollectionViewCell.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 23.07.2025.
//

import UIKit

final class NewsCollectionViewCell: UICollectionViewCell {

    // MARK: - UI Properties
    private lazy var titleLabel = AppLabel(type: .title)
    private lazy var dateLabel = AppLabel(type: .date)
    private lazy var imageView = AppImageView(type: .newsImage)
    private lazy var categoryLabel = CategoryView()
    private lazy var shareButtonView = ShareButtonView()

    private lazy var titleAndDateStackView = AppStackView([titleLabel, dateLabel], axis: .vertical, spacing: 5)

    private lazy var textAndShareStackView = AppStackView([titleAndDateStackView, shareButtonView], axis: .horizontal, spacing: 10)

    private lazy var stackView = AppStackView([textAndShareStackView, imageView, categoryLabel], axis: .vertical, spacing: 10, distribution: .equalSpacing)

    private var imageLoader: ImageLoaderProtocol?

    var onImageLoaded: (() -> Void)?
    var onShareButtonTapped: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with news: News, imageLoader: ImageLoaderProtocol?) {
        guard let imageLoader else { return }
        imageView.setImage(from: news.titleImageUrl, with: imageLoader) { [weak self] in
            self?.onImageLoaded?()
        }
        titleLabel.text = news.title
        dateLabel.text = news.publishedDate
        categoryLabel.setText(news.categoryType)
    }
}

// MARK: - Supporting methods
private extension NewsCollectionViewCell {
    func setupUI() {
        contentView.backgroundColor = .clear
        contentView.addSubviews(stackView)

        setupLayout()
    }

    func setupLayout() {
        stackView.setConstraints(insets: .init(top: 10, left: 0, bottom: 10, right: 0))

        titleAndDateStackView.isLayoutMarginsRelativeArrangement = true
        titleAndDateStackView.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)

        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1000/1600).isActive = true

        titleAndDateStackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        shareButtonView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        shareButtonView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        titleAndDateStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }

    func setupAction() {
        shareButtonView.onShareButtonTapped = { [weak self] in
            self?.onShareButtonTapped?()
        }
    }
}
