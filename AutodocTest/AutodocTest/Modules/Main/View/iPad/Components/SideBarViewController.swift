//
//  SideBarViewController.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 06.08.2025.
//

import UIKit

enum CategorySection {
    case main
}

final class SideBarViewController: UIViewController {
    private let items = ["Новости", "Другое"]

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<CategorySection, String>!
    private var categoryCell: UICollectionView.CellRegistration<UICollectionViewListCell, String>!
    private var header: UICollectionView.SupplementaryRegistration<UICollectionViewListCell>!


    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupDataSource()
        registerCell()
        registerHeader()
        setupSnapshot()
    }

    func setupCollectionView() {
        view.backgroundColor = .systemBackground

        var config = UICollectionLayoutListConfiguration(appearance: .sidebar)
        config.showsSeparators = false
        config.headerMode = .supplementary

        let layout = UICollectionViewCompositionalLayout.list(using: config)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        view.addSubviews(collectionView)
        collectionView.setConstraints()

        collectionView.delegate = self

    }

    func registerCell() {
        categoryCell = UICollectionView.CellRegistration<UICollectionViewListCell, String> { [weak self]
            cell, indexPath, item in
            var content = UIListContentConfiguration.sidebarCell()
            content.textProperties.font = .systemFont(ofSize: 30, weight: .regular)
            content.text = item

            var backgroundConfig = UIBackgroundConfiguration.listSidebarCell()
            backgroundConfig.cornerRadius = 10

            backgroundConfig.backgroundInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)


            self?.designSelectedCell(cell: cell, backgroundConfig: backgroundConfig, content: content)

            cell.accessories = [.disclosureIndicator()]
        }
    }

    func designSelectedCell(cell: UICollectionViewListCell, backgroundConfig: UIBackgroundConfiguration, content: UIListContentConfiguration) {
        cell.configurationUpdateHandler = { cell, state in
            var updatedBackground = backgroundConfig
            var updatedContent = content
            if state.isSelected {
                updatedBackground.backgroundColor = .systemRed
                updatedContent.textProperties.color = .white
            } else {
                updatedBackground.backgroundColor = .clear
                updatedContent.textProperties.color = .black

            }
            cell.contentConfiguration = updatedContent
            cell.backgroundConfiguration = updatedBackground
        }
    }

    func registerHeader() {
        header = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { header, _, indexPath in
            var content = UIListContentConfiguration.sidebarHeader()
            content.text = "Категории"
            content.textProperties.font = .systemFont(ofSize: 30, weight: .bold)
            content.textProperties.color = .black
            header.contentConfiguration = content
        }
    }

    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<CategorySection, String>(collectionView: collectionView)
        { [weak self] collectionView, indexPath, news in
            guard let self else { return UICollectionViewCell() }
            return collectionView.dequeueConfiguredReusableCell(using: categoryCell, for: indexPath, item: news)
        }

        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self else { return UICollectionReusableView() }
            return collectionView.dequeueConfiguredReusableSupplementary(using: header, for: indexPath)
        }
    }

    func setupSnapshot(animatingDifferences: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<CategorySection, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)

        DispatchQueue.main.async { [weak self] in
            self?.dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        }
    }
}

extension SideBarViewController: UICollectionViewDelegate {

}
