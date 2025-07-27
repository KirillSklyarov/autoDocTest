//
//  AppActionSheet.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 27.07.2025.
//

import UIKit

final class AppActionSheet: UIViewController {

    // MARK: - UI Properties
    private lazy var contentView = ActionSheetContentView()
    private lazy var dismissButtonView = AppActionSheetDismissView()
    private lazy var contentStack = AppStackView([contentView, dismissButtonView], axis: .vertical, spacing: 5, distribution: .fillProportionally)

    // MARK: - Other Properties
    private var bottomConstraint: NSLayoutConstraint!

    var onDismissButtonTapped: (() -> Void)?

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showContentStack()
    }

    func configureUI(with data: News) {
        contentView.configureUI(with: data)
    }
}

// MARK: - Supporting methods
private extension AppActionSheet {
    func showContentStack() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.bottomConstraint.constant = -10
            self?.view.layoutIfNeeded()
        }
    }

    func hideContentStack() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.bottomConstraint.constant = 250
            self?.view.layoutIfNeeded()
        }
    }
}

// MARK: - Setup Actions
private extension AppActionSheet {
    func setupAction() {
        dismissButtonView.onButtonTapped = { [weak self] in
            guard let self else { return }
            hideContentStack()
            onDismissButtonTapped?()
        }

//        titleLabel.onButtonTapped = { [weak self] in
//            guard let self else { return }
//            print("Test")
//        }
    }
}

// MARK: - Setup UI
private extension AppActionSheet {
    func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubviews(contentStack)

        setupLayout()
        setupGesture()
    }

    func setupLayout() {
        bottomConstraint = contentStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 250)
        bottomConstraint.isActive = true
        contentStack.setLocalConstraints(left: 0, right: 0)

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: contentStack.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentStack.trailingAnchor),
        ])
    }
}

// MARK: - Setup Gesture
private extension AppActionSheet {
    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func viewTapped() {
        hideContentStack()
        onDismissButtonTapped?()
    }
}
