//
//  File.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 23.07.2025.
//

import UIKit

extension UICollectionReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionView {

    func registerCell<Cell: UICollectionViewCell>(_ cellClass: Cell.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.identifier)
    }

    func dequeueCell<Cell: UICollectionViewCell>(for indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as? Cell
        else {
            fatalError("Cannot dequeue cell with identifier: \(Cell.identifier) at \(indexPath)")
        }
        return cell
    }

    func registerSupplementaryView<View: UICollectionReusableView>(ofKind kind: String, viewClass: View.Type) {
        register(viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: viewClass.identifier)
    }

    func dequeueSupplementaryView<View: UICollectionReusableView>(
        ofKind kind: String,
        for indexPath: IndexPath
    ) -> View {
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: View.identifier, for: indexPath) as? View
        else {
            fatalError("Cannot dequeue supplementary view \(View.identifier) for kind \(kind) at \(indexPath)")
        }
        return view
    }
}
