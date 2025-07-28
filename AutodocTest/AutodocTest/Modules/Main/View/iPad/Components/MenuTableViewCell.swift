//
//  MenuTableViewCell.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 28.07.2025.
//

import UIKit

final class MenuTableViewCell: UITableViewCell {

    private lazy var titleLabel = AppLabel(type: .categorySubtitle)
    private lazy var titleImage = AppImageView(type: .newsMegaphone)
    private lazy var imageContainer: UIView = {
        let view = UIView()
        view.addSubviews(titleImage)
        titleImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return view
    }()

    private lazy var contentStackView = AppStackView([imageContainer, titleLabel, UIView()], axis: .horizontal, spacing: 10)

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension MenuTableViewCell {
    func configureCell(with title: String) {
        titleLabel.text = title
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            contentStackView.backgroundColor = .systemRed
            titleLabel.textColor = .white
            titleImage.changeColor(.white)
        } else {
            contentStackView.backgroundColor = .clear
            titleLabel.textColor = .black
            titleImage.changeColor(.systemRed)
        }
    }
}

// MARK: - Configure cell
private extension MenuTableViewCell {
    func setupCell() {
        backgroundColor = .clear
        contentView.addSubviews(contentStackView)
        contentStackView.layer.cornerRadius = 10
        contentStackView.clipsToBounds = true

        setupLayout()
    }

    func setupLayout() {
        contentStackView.setConstraints(insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        imageContainer.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
