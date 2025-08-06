//
//  CollectionViewController.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 23.07.2025.
//

import UIKit

private enum Section {
    case main
}

final class NewsCollectionView: UICollectionView {

    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, News>!
    private var newsCell: UICollectionView.CellRegistration<NewsCollectionViewCell, News>!
    private var footer: UICollectionView.SupplementaryRegistration<LoadingFooterView>!

    var imageLoader: ImageLoaderProtocol?

    var isLoadingNextPage = false {
        didSet { reloadFooter() }
    }

    var onCellSelected: ((News) -> Void)?
    var onLoadNextPage: (() -> Void)?
    var onImageLoaded: (() -> Void)?
    var onShareButtonTapped: ((News) -> Void)?

    // MARK: - Init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = Self.makeLayout()
        super.init(frame: frame, collectionViewLayout: layout)
        cellRegistration()
        footerRegistration()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(news: [News]) {
        setupSnapshot(data: news)
    }
}

private extension NewsCollectionView {
    static func makeLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(330)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(330)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(8)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8

        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80))

        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)

        section.boundarySupplementaryItems = [footer]

        return UICollectionViewCompositionalLayout(section: section)
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

    func setupUI() {
        backgroundColor = .clear
        indicatorStyle = .white

        delegate = self

        setupDataSource()
    }

    func setupDataSource() {
        diffableDataSource = UICollectionViewDiffableDataSource<Section, News>(collectionView: self)
        { [weak self] collectionView, indexPath, news in
            guard let self else { return UICollectionViewCell() }
            return collectionView.dequeueConfiguredReusableCell(using: newsCell, for: indexPath, item: news)
        }

        diffableDataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
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
            self?.diffableDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        }
    }

    func reloadFooter() {
        var snapshot = diffableDataSource.snapshot()
        snapshot.reloadSections([.main])
        diffableDataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: – UICollectionViewDelegate
extension NewsCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = diffableDataSource.itemIdentifier(for: indexPath) else { return }
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
