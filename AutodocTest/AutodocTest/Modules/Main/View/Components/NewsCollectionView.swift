//
//  CollectionViewController.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 23.07.2025.
//

import UIKit

final class NewsCollectionView: UICollectionView {

//    // MARK: – Data model
//    private var items: [(image: UIImage?, title: String)] = []

    // MARK: – Init

//    init() {
//        super.init(frame: .zero, collectionViewLayout: Self.makeLayout())
//        commonInit()
//    }

    var onCellSelected: ((News) -> Void)?

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = Self.makeLayout()
        super.init(frame: frame, collectionViewLayout: layout)
        setupUI()
    }

//    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
//        super.init(frame: frame, collectionViewLayout: layout)
//        commonInit()
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        // если вы будете использовать сториборд/интерфейсбилдер,
//        // убедитесь, что после инициализации layout тоже установлен.
//        collectionViewLayout = Self.makeLayout()
//        commonInit()
//    }

    private func setupUI() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false

        registerCell(NewsCollectionViewCell.self)

        dataSource = self
        delegate = self

    }

    // MARK: – Public API
    /// Передать данные и обновить коллекцию
    func setItems(_ items: [(image: UIImage?, title: String)]) {
//        self.items = items
        reloadData()
    }

    // MARK: – Layout

    private static func makeLayout() -> UICollectionViewLayout {
        // Одна ячейка на всю ширину, высота — estimate
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

// MARK: – UICollectionViewDataSource, UICollectionViewDelegate
extension NewsCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        News.mockData.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueCell(for: indexPath) as NewsCollectionViewCell
        let news = News.mockData[indexPath.item]
        cell.configure(with: news)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let news = News.mockData[indexPath.item]
        onCellSelected?(news)
    }
}
