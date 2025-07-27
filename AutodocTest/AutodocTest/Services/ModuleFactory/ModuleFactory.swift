//
//  MainModuleFactoryProtocol.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 27.07.2025.
//

import UIKit


enum MainModule {
    case main
}

protocol ModuleFactoryProtocol {
    func makeModule(for module: MainModule) -> UIViewController
}

// Фабрика экранов модуля главного экрана
final class ModuleFactory: ModuleFactoryProtocol {

    // MARK: - Properties
    private let networkService: NetworkServiceProtocol
    private let imageLoader: ImageLoaderProtocol

    // MARK: - Init
    init(networkService: NetworkServiceProtocol, imageLoader: ImageLoaderProtocol) {
        self.networkService = networkService
        self.imageLoader = imageLoader
    }
}


extension ModuleFactory {
    func makeModule(for module: MainModule) -> UIViewController {
        switch module {
        case .main: return makeMainModule()
        }
    }

    func makeMainModule() -> UINavigationController {
        let viewModel = MainViewModel(networkService: networkService, imageLoader: imageLoader)
        let vc = MainViewController(viewModel: viewModel, imageLoader: imageLoader)
        viewModel.view = vc
        let navVC = UINavigationController(rootViewController: vc)
        return navVC
    }
}
