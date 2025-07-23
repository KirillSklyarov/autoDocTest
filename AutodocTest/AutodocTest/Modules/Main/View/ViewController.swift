//
//  ViewController.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 23.07.2025.
//

import UIKit
import SafariServices

final class MainViewController: UIViewController {

    private lazy var newsCollectionView = NewsCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }

    func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubviews(newsCollectionView)
        newsCollectionView.setConstraints(isSafeArea: true, allInsets: 10)
    }

    func setupActions() {
        newsCollectionView.onCellSelected = { [weak self] news in
            guard let self = self else { return }
            showURL(url: news.fullUrl)
        }
    }


    func showURL(url: String) {
        guard let url = URL(string: url) else { printContent("Invalid URL: \(url)"); return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}
