//
//  MenuViewConroller.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 28.07.2025.
//

import UIKit

final class MenuViewController: UITableViewController {
    private let items = ["Новости", "Другое"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        tableView.backgroundColor = .systemGray3
        tableView.registerCell(MenuTableViewCell.self)
        tableView.rowHeight = 70
        tableView.separatorStyle = .none
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(indexPath) as MenuTableViewCell
        let title = items[indexPath.row]
        cell.configureCell(with: title)
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return CategoryHeaderView()
    }
}
