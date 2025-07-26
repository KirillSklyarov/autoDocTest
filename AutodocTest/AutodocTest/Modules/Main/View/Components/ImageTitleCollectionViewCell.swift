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

    private lazy var titleAndDateStackView = AppStackView([titleLabel, dateLabel], axis: .vertical, spacing: 5)

    private lazy var stackView = AppStackView([titleAndDateStackView, imageView, categoryLabel], axis: .vertical, spacing: 10, distribution: .equalSpacing)

    private var imageLoader: ImageLoader?

    var onImageLoaded: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with news: News, imageLoader: ImageLoader?) {
        guard let imageLoader else { return }
        imageView.setImage(from: news.titleImageUrl, with: imageLoader) { [weak self] in
//            print(#function)
            self?.onImageLoaded?()
        }
        titleLabel.text = news.title
        dateLabel.text = news.publishedDate
        categoryLabel.setText(news.categoryType)
    }

    private func setupUI() {
        contentView.backgroundColor = .clear
        contentView.addSubviews(stackView)

        setupLayout()

    }

    private func setupLayout() {
        stackView.setConstraints(insets: .init(top: 10, left: 0, bottom: 10, right: 0))

        titleAndDateStackView.isLayoutMarginsRelativeArrangement = true
        titleAndDateStackView.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)

        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1000/1600).isActive = true
    }
}
