//
//  MainModuleFactoryProtocol.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 27.07.2025.
//

import UIKit

protocol ModuleFactoryProtocol {
    func makeModule(for module: MainModule) -> UIViewController
}

enum MainModule {
    case main
    case menuForIPad
    case mainSplitForIPad
}

// Фабрика экранов модуля главного экрана
final class ModuleFactory: ModuleFactoryProtocol {

    // MARK: - Properties
    private let networkService: NetworkServiceProtocol
    private let imageLoader: ImageLoaderProtocol
    private let router: Router

    // MARK: - Init
    init(networkService: NetworkServiceProtocol, imageLoader: ImageLoaderProtocol, router: Router) {
        self.networkService = networkService
        self.imageLoader = imageLoader
        self.router = router
    }
}


extension ModuleFactory {
    func makeModule(for module: MainModule) -> UIViewController {
        switch module {
        case .main: return makeMainModule()
        case .menuForIPad: return makeMenuForIPadModule()
        case .mainSplitForIPad: return makeMainSplitForIPadModule()
        }
    }

    func makeMainModule() -> UINavigationController {
        let viewModel = MainViewModel(networkService: networkService, imageLoader: imageLoader, router: router)
        let vc = MainViewController(viewModel: viewModel, imageLoader: imageLoader)
        viewModel.view = vc
        let navVC = UINavigationController(rootViewController: vc)
        return navVC
    }

    func makeMenuForIPadModule() -> UINavigationController {
        let vc = SideBarViewController()
        let navVC = UINavigationController(rootViewController: vc)
        return navVC
    }

    func makeMainSplitForIPadModule() -> UISplitViewController {
        let vc = MainSplitViewController(moduleFactory: self)
        return vc
    }
}
