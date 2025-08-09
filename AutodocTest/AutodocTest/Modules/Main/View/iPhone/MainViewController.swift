//
//  ViewController.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 23.07.2025.
//

import UIKit
import Combine

protocol MainDisplaying: AnyObject { }

final class MainViewController: UIViewController, MainDisplaying {

    private lazy var newsCollectionView = NewsCollectionView()
    private var newsCollectionAdapter: CollectionViewAdapting?

    private lazy var activityIndicator = AppActivityIndicator()

    private var cancellables: Set<AnyCancellable> = []

    private let viewModel: MainViewModelling
    private let imageLoader: ImageLoaderProtocol

    // MARK: - Init
    init(viewModel: MainViewModelling, imageLoader: ImageLoaderProtocol) {
        self.viewModel = viewModel
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
        viewModel.sendEvent(.viewDidLoad)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        newsCollectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - Setup UI
private extension MainViewController {
    func setupInitialState() {
        setupUI()
        setupCollectionViewAdapter()
        dataBinding()
    }

    func setupUI() {
        view.backgroundColor = .black

        setupNavigation()
        setupNewsCollectionView()
        setupActivityIndicator()
    }

    func setupNewsCollectionView() {
        view.addSubviews(newsCollectionView)
        newsCollectionView.setConstraints(isSafeArea: true, allInsets: 0)
    }

    func setupActivityIndicator() {
        view.addSubviews(activityIndicator)
        setupActivityIndicatorLayout()
    }

    func setupActivityIndicatorLayout() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func setupCollectionViewAdapter() {
        newsCollectionAdapter = CollectionAdapter(collectionView: newsCollectionView, imageLoader: imageLoader)

        newsCollectionAdapter?.onCellSelected = { [weak self] news in
            guard let self else { return }
            viewModel.sendEvent(.openURL(url: news.fullUrl))
        }

        newsCollectionAdapter?.onLoadNextPage = { [weak self] in
            guard let self else { return }
            viewModel.sendEvent(.loadNextPage)
        }

        newsCollectionAdapter?.onShareButtonTapped = { [weak self] news in
            self?.viewModel.sendEvent(.shareButtonTapped(data: news))
        }
    }

}

// MARK: - Setup navigation
private extension MainViewController {
    func setupNavigation() {
        title = "Новости"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .black
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        setupToggleMenuForIPad()

    }

    func setupToggleMenuForIPad() {
        guard splitViewController != nil else { return }
        let image = AppImageView(type: .sideBarForIpad)
        let sideBarButtonItem = UIBarButtonItem(image: image.image, style: .plain, target: self, action: #selector(toggleMenu))
        navigationItem.leftBarButtonItem = sideBarButtonItem
    }

    @objc private func toggleMenu() {
        if splitViewController?.displayMode == .oneBesideSecondary {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.splitViewController?.preferredDisplayMode = .secondaryOnly
            }
        } else {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.splitViewController?.preferredDisplayMode = .oneBesideSecondary
            }
        }
    }
}

// MARK: - Data binding
private extension MainViewController {
    func dataBinding() {
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] state in
                guard let self else { print(#function, "self is nil"); return }
                switch state {
                case .idle: setupInitialState()
                case .loading: showLoading(true)
                case .success(let data):
//                    print("🔑 Count: \(data.count)")
                    showLoading(false)
                    newsCollectionAdapter?.isLoadingNextPage = false
                    newsCollectionAdapter?.apply(news: data)
                case .paginating:
                    newsCollectionAdapter?.isLoadingNextPage = true
                case .error(_): break
                }
            })
            .store(in: &cancellables)
    }
}

// MARK: - Supporting methods
private extension MainViewController {
    func setScrollEnable(_ enable: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.newsCollectionView.isScrollEnabled = enable
        }
    }

    func showLoading(_ bool: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            bool ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
    }
}
