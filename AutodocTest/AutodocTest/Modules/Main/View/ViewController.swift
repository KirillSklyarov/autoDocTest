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
    func showLoading()
}

final class MainViewController: UIViewController, MainDisplaying {

    private lazy var newsCollectionView = NewsCollectionView()
    private lazy var activityIndicator = AppActivityIndicator()

    private var cancellables: Set<AnyCancellable> = []

    let viewModel: MainViewModelling

    // MARK: - Init
    init(viewModel: MainViewModelling) {
        self.viewModel = viewModel
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

    func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubviews(newsCollectionView)
        newsCollectionView.setConstraints(isSafeArea: true, allInsets: 10)

        setupActivityIndicator()
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

    func setupActions() {
        newsCollectionView.onCellSelected = { [weak self] news in
            guard let self = self else { return }
            showURL(url: news.fullUrl)
        }
    }

    func dataBinding() {
        viewModel.newsDataPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] news in
                guard let self, let news else { print(#function, "news is nil"); return }
                activityIndicator.stopAnimating()
                newsCollectionView.apply(news: news)
            })
            .store(in: &cancellables)
    }

    func showLoading() {
        activityIndicator.startAnimating()
    }

    func showURL(url: String) {
        guard let url = URL(string: url) else { printContent("Invalid URL: \(url)"); return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}
