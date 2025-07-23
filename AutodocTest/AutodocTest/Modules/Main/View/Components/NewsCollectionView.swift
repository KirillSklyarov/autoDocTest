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

    var onCellSelected: ((News) -> Void)?

    // MARK: - Init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = Self.makeLayout()
        super.init(frame: frame, collectionViewLayout: layout)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: – Layout
    private static func makeLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(100)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(8)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8

        return UICollectionViewCompositionalLayout(section: section)
    }
}

private extension NewsCollectionView {
    func setupUI() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false

        registerCell(NewsCollectionViewCell.self)

        delegate = self

        setupDataSource()
    }

    func setupDataSource() {
        diffableDataSource = UICollectionViewDiffableDataSource<Section, News>(collectionView: self)
        { collectionView, indexPath, news in
            let cell = collectionView.dequeueCell(for: indexPath) as NewsCollectionViewCell
            cell.configure(with: news)
            return cell
        }

        setupSnapshot(data: News.mockData)
    }

    func setupSnapshot(data: [News], animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, News>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data, toSection: .main)

        snapshot.reloadItems(data)

        DispatchQueue.main.async { [weak self] in
            self?.diffableDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        }
    }
}

// MARK: – UICollectionViewDelegate
extension NewsCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let news = News.mockData[indexPath.item]
        onCellSelected?(news)
    }
}
