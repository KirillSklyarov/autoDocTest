//
//  CollectionAdapter.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 06.08.2025.
//

import UIKit

private enum Section {
    case main
}

final class CollectionAdapter: NSObject {

    // MARK: - Properties
    private let collectionView: UICollectionView
    private var imageLoader: ImageLoaderProtocol

    private var dataSource: UICollectionViewDiffableDataSource<Section, News>!
    private var newsCell: UICollectionView.CellRegistration<NewsCollectionViewCell, News>!
    private var footer: UICollectionView.SupplementaryRegistration<LoadingFooterView>!

    var isLoadingNextPage = false

    var onImageLoaded: (() -> Void)?
    var onShareButtonTapped: ((News) -> Void)?
    var onCellSelected: ((News) -> Void)?
    var onLoadNextPage: (() -> Void)?

    // MARK: - Init
    init(collectionView: UICollectionView, imageLoader: ImageLoaderProtocol) {
        self.collectionView = collectionView
        self.imageLoader = imageLoader
        super.init()
        cellRegistration()
        footerRegistration()
        setupDataSource()
//        apply(news: [])

        self.collectionView.delegate = self
    }

    func apply(news: [News]) {
        print(news)
        setupSnapshot(data: news)
    }
}


private extension CollectionAdapter {
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

            cell.onImageLoaded = { [weak self] in
                guard let self else { return }
                onImageLoaded?()
            }

            cell.onShareButtonTapped = { [weak self] in
                self?.onShareButtonTapped?(news)
            }
        }
    }

    func footerRegistration() {
        footer = UICollectionView.SupplementaryRegistration<LoadingFooterView>(elementKind: UICollectionView.elementKindSectionFooter) { [weak self] footer, _, indexPath in
            guard let self else { return }
            if isLoadingNextPage {
                footer.startAnimating()
            } else {
                footer.stopAnimating()
            }
        }
    }

}

// MARK: – UICollectionViewDelegate
extension CollectionAdapter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        onCellSelected?(item)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let visibleHeight = scrollView.bounds.size.height
        let offsetY = scrollView.contentOffset.y

        guard contentHeight > visibleHeight else { return }

        if offsetY + visibleHeight >= contentHeight * 0.8 {
            onLoadNextPage?()
        }

        if offsetY + visibleHeight >= contentHeight {
            onLoadNextPage?()
        }
    }
}
