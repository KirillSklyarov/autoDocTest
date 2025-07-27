//
//  AppActionSheetButtonType.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 27.07.2025.
//

import UIKit

final class AppActionSheetDismissView: UIView {

    // MARK: - Properties
    private lazy var actionSheetButton = AppLabel(type: .title)
    private lazy var blurView = AppBlurView()

    private let viewHeight: CGFloat = 50
    var onButtonTapped: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupTapGestureRecognizer()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension AppActionSheetDismissView {

    func setupUI() {
        layer.cornerRadius = 10
        layer.masksToBounds = true
        actionSheetButton.text = "Отмена"
        actionSheetButton.textAlignment = .center

        addSubviews(blurView, actionSheetButton)
        setupLayout()
    }

    func setupLayout() {
        actionSheetButton.setConstraints()
        heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        blurView.setConstraints()
    }

    func setupTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        actionSheetButton.isUserInteractionEnabled = true
        actionSheetButton.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func buttonTapped() {
        print(#function)
        onButtonTapped?()
    }
}
