//
//  ViewController.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 23.07.2025.
//

import UIKit
import SafariServices
import Combine

protocol MainDisplaying: AnyObject {
    func setupInitialState()
    func showLoading(_ bool: Bool)
    func setScrollEnable(_ enable: Bool)
}

final class MainViewController: UIViewController, MainDisplaying {

    private lazy var newsCollectionView = NewsCollectionView()
    private lazy var activityIndicator = AppActivityIndicator()

    private var cancellables: Set<AnyCancellable> = []

    private let viewModel: MainViewModelling
    private let imageLoader: ImageLoader

    // MARK: - Init
    init(viewModel: MainViewModelling, imageLoader: ImageLoader) {
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
        viewModel.initialize()
    }

    func setupInitialState() {
        setupUI()
        setupActions()
        dataBinding()
    }

    func showLoading(_ bool: Bool) {
        DispatchQueue.main.async { [weak self] in
            if bool {
                self?.activityIndicator.startAnimating()
            } else {
                self?.activityIndicator.stopAnimating()
            }
        }
    }

    func setScrollEnable(_ enable: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.newsCollectionView.isScrollEnabled = enable
        }
    }
}

// MARK: - Setup UI
private extension MainViewController {
    func setupUI() {
        setupNavigation()

        view.backgroundColor = .black
        setupNewsCollectionView()
        setupActivityIndicator()
    }

    func setupNewsCollectionView() {
        view.addSubviews(newsCollectionView)
        newsCollectionView.setConstraints(isSafeArea: true, allInsets: 0)
        newsCollectionView.imageLoader = imageLoader
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
    }
}

// MARK: - Setup Actions & Data binding
private extension MainViewController {
    func setupActions() {
        newsCollectionView.onCellSelected = { [weak self] news in
            guard let self else { return }
            showURL(url: news.fullUrl)
        }

        newsCollectionView.onLoadNextPage = { [weak self] in
            guard let self else { return }
            viewModel.loadNextPage()
        }

        newsCollectionView.onShareButtonTapped = { [weak self] news in
            self?.showShareAlert(with: news)
        }
    }

    func showShareAlert(with data: News) {
        let vc = AppActionSheet()
        vc.configureUI(with: data)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)

        vc.onDismissButtonTapped = { [weak self] in
            guard let self, let parent = navigationController?.visibleViewController else { print("Error: No parent"); return }
            parent.dismiss(animated: true)
        }
    }

    func dataBinding() {
        viewModel.newsDataPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] news in
                guard let self, let news else { return }
                print("🔑 Count: \(news.count)")
                activityIndicator.stopAnimating()
                newsCollectionView.apply(news: news)
            })
            .store(in: &cancellables)

        viewModel.isLoadingNextPagePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isLoading in
                guard let self else { print(#function, "self is nil"); return }
                newsCollectionView.isLoadingNextPage = isLoading
            })
            .store(in: &cancellables)
    }

    func showURL(url: String) {
        guard let url = URL(string: url) else { printContent("Invalid URL: \(url)"); return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}
