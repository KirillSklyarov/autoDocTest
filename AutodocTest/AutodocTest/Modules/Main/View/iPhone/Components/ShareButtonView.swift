//
//  CategoryView 2.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 27.07.2025.
//

import UIKit

final class ShareButtonView: UIView {

    private lazy var roundView: UIView = {
        let view = UIView()
        view.backgroundColor = AppConstants.Colors.darkGray
        view.clipsToBounds = true
        view.widthAnchor.constraint(equalToConstant: 30).isActive = true
        view.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        return view
    }()
    private lazy var dotsImageView = AppImageView(type: .dotsImage)

    var onShareButtonTapped: (() -> Void)?

    init() {
        super.init(frame: .zero)
        setupUI()
        setupAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        roundView.layer.cornerRadius = roundView.bounds.height / 2
    }
}

private extension ShareButtonView {
    func setupUI() {
        backgroundColor = .clear
        roundView.addSubviews(dotsImageView)
        addSubviews(roundView)
        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            roundView.topAnchor.constraint(equalTo: topAnchor),
            roundView.trailingAnchor.constraint(equalTo: trailingAnchor),

            dotsImageView.centerXAnchor.constraint(equalTo: roundView.centerXAnchor),
            dotsImageView.centerYAnchor.constraint(equalTo: roundView.centerYAnchor),
        ])
    }

    func setupAction() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func didTap() {
        onShareButtonTapped?()
    }
}
