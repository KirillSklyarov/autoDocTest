//
//  CollectionViewController.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 23.07.2025.
//

import UIKit

final class NewsCollectionView: UICollectionView {

    // MARK: - Init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = CollectionLayoutProvider.makeLayout()
        super.init(frame: frame, collectionViewLayout: layout)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        backgroundColor = .clear
        indicatorStyle = .white
    }
}
