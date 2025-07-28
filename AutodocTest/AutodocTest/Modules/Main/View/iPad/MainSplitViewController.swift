//
//  MainSplitViewController.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 28.07.2025.
//

import UIKit

final class MainSplitViewController: UISplitViewController {

    let moduleFactory: ModuleFactoryProtocol

    // MARK: - Init
    init(moduleFactory: ModuleFactoryProtocol) {
        self.moduleFactory = moduleFactory
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Setup UI
private extension MainSplitViewController {
    func setupUI() {
        let navMenu = moduleFactory.makeModule(for: .menuForIPad)
        let navMain = moduleFactory.makeModule(for: .main)

        viewControllers = [navMenu, navMain]
        preferredDisplayMode = .oneBesideSecondary
    }

    @objc func toggleMenu() {
        guard let svc = splitViewController else { return }

        svc.preferredDisplayMode = svc.displayMode == .oneBesideSecondary
        ? .secondaryOnly
        : .oneBesideSecondary
    }
}
