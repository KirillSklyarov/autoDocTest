//
//  ToastView.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 27.07.2025.
//

import UIKit

enum ToastType {
    case linkCopied
}

final class ToastView: UIView {

    // MARK: - Properties
    private lazy var capsuleView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        return view
    }()

    private lazy var toastLabel = AppLabel(type: .toastTitle)
    private lazy var checkmarkImageView = AppImageView(type: .checkmark)

    private lazy var contentStackView = AppStackView([checkmarkImageView, toastLabel], axis: .horizontal, spacing: 10)

    // MARK: - Init
    init(type: ToastType) {
        super.init(frame: .zero)
        setupUI(type)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showToast( duration: TimeInterval = 2.0) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            capsuleView.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: duration, options: .curveEaseOut, animations: { [weak self] in
                guard let self = self else { return }
                capsuleView.alpha = 0.0
            }) { [weak self] _ in
                guard let self = self else { return }
                capsuleView.removeFromSuperview()
            }
        }
    }
}

private extension ToastView {
    func setupUI(_ type: ToastType) {
        capsuleView.addSubviews(contentStackView)
        addSubviews(capsuleView)

        setupLayout()
        setupTypes(type)
    }

    func setupTypes(_ type: ToastType) {
        switch type {
        case .linkCopied: toastLabel.text = "Ссылка скопирована"
        }
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            capsuleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            capsuleView.centerYAnchor.constraint(equalTo: centerYAnchor),

            contentStackView.leadingAnchor.constraint(equalTo: capsuleView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: capsuleView.trailingAnchor, constant: -16),
            contentStackView.topAnchor.constraint(equalTo: capsuleView.topAnchor, constant: 12),
            contentStackView.bottomAnchor.constraint(equalTo: capsuleView.bottomAnchor, constant: -12)
        ])
    }
}
