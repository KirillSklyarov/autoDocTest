//
//  AppBlurView.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 27.07.2025.
//

import UIKit

final class AppBlurView: UIVisualEffectView {

    private let blurEffect = UIBlurEffect(style: .dark)

    override init(effect: UIVisualEffect?) {
        super.init(effect: effect ?? blurEffect)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
