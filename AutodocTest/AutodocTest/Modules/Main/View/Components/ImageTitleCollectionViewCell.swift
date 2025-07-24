//
//  ImageTitleCollectionViewCell.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 23.07.2025.
//

import UIKit

final class NewsCollectionViewCell: UICollectionViewCell {

    // MARK: - UI Properties
    private lazy var imageView = AppImageView(type: .newsImage)
    private lazy var titleLabel = AppLabel(type: .title)

    private lazy var stackView = AppStackView([imageView, titleLabel], axis: .horizontal, spacing: 10)

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
//        loadImage(from: news.titleImageUrl)
        titleLabel.text = news.title
    }

    private func setupUI() {
        contentView.backgroundColor = .lightGray
        layer.cornerRadius = 10
        clipsToBounds = true

        contentView.addSubviews(stackView)
        stackView.setConstraints(allInsets: 10)
    }
}
