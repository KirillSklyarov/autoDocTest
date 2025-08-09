//
//  CollectionAdapter.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 06.08.2025.
//

import UIKit

protocol CollectionViewAdapting {
    func apply(news: [News])

    var isLoadingNextPage: Bool { get set }

    var onShareButtonTapped: ((News) -> Void)? { get set }
    var onCellSelected: ((News) -> Void)? { get set }
    var onLoadNextPage: (() -> Void)? { get set }
}

private enum Section {
    case main
}

final class CollectionAdapter: NSObject, CollectionViewAdapting {

    // MARK: - Properties
    private let collectionView: UICollectionView
    private var imageLoader: ImageLoaderProtocol

    private var dataSource: UICollectionViewDiffableDataSource<Section, News>!
    private var newsCell: UICollectionView.CellRegistration<NewsCollectionViewCell, News>!
    private var footer: UICollectionView.SupplementaryRegistration<LoadingFooterView>!

    var isLoadingNextPage = false

    var onShareButtonTapped: ((News) -> Void)?
    var onCellSelected: ((News) -> Void)?
    var onLoadNextPage: (() -> Void)?

    // MARK: - Init
    init(collectionView: UICollectionView, imageLoader: ImageLoaderProtocol) {
        self.collectionView = collectionView
        self.imageLoader = imageLoader
        super.init()

        initialSetup()
    }

    func apply(news: [News]) {
        setupSnapshot(data: news)
    }

    func reloadFooter() {
        var snapshot = dataSource.snapshot()
        snapshot.reloadSections([.main])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

private extension CollectionAdapter {
    func initialSetup() {
        collectionViewSetup()
        cellRegistration()
        footerRegistration()
        setupDataSource()
    }

    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, News>(collectionView: collectionView)
        { [weak self] collectionView, indexPath, news in
            guard let self else { return UICollectionViewCell() }
            return collectionView.dequeueConfiguredReusableCell(using: newsCell, for: indexPath, item: news)
        }

        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self else { return UICollectionReusableView() }
            return collectionView.dequeueConfiguredReusableSupplementary(using: footer, for: indexPath)
        }

        setupSnapshot(data: [])
    }

    func setupSnapshot(data: [News], animatingDifferences: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, News>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data, toSection: .main)

        DispatchQueue.main.async { [weak self] in
            self?.dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        }
    }

    func cellRegistration() {
        newsCell =
        UICollectionView.CellRegistration<NewsCollectionViewCell, News> { [weak self] cell, indexPath, news in
            cell.configure(with: news, imageLoader: self?.imageLoader)

            cell.onShareButtonTapped = { [weak self] in
                self?.onShareButtonTapped?(news)
            }
        }
    }

    func footerRegistration() {
        footer = UICollectionView.SupplementaryRegistration<LoadingFooterView>(elementKind: UICollectionView.elementKindSectionFooter) { [weak self] footer, _, indexPath in
            guard let self else { Log.app.errorAlways("self is nil"); return }
            if isLoadingNextPage {
                footer.startAnimating()
            } else {
                footer.stopAnimating()
            }
        }
    }

    func collectionViewSetup() {
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
    }
}

// MARK: – UICollectionViewDelegate
extension CollectionAdapter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        onCellSelected?(item)
    }
}

// MARK: – UICollectionViewDataSourcePrefetching
extension CollectionAdapter: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let maxIndex = indexPaths.map { $0.item }.max() ?? 0
        let total = dataSource.snapshot().itemIdentifiers.count
        if maxIndex >= Int(Double(total) * 0.85) {
            onLoadNextPage?()
        }
    }
}
