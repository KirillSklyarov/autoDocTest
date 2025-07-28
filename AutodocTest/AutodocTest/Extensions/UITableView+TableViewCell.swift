//
//  File.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 28.07.2025.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String.init(describing: self)
    }
}

extension UITableViewHeaderFooterView {
    static var identifier: String {
        return String(describing: self)
    }
}


extension UITableView {
    func registerCell<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.identifier)
    }

    func dequeueCell<Cell: UITableViewCell>(_ indexPath: IndexPath) -> Cell {
        guard let cell = self.dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as? Cell
        else { fatalError("Fatal error for cell at \(indexPath)") }

        return cell
    }

    func registerHeaderFooter<Header: UITableViewHeaderFooterView>(_ headerClass: Header.Type) {
            register(headerClass, forHeaderFooterViewReuseIdentifier: headerClass.identifier)
        }
}
