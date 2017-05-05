//
//  TableViewDataSourceWithSections.swift
//  888ru
//
//  Created by Nikolay Ischuk on 07.02.17.
//  Copyright © 2017 easyverzilla. All rights reserved.
//

import Foundation
import UIKit

class TableViewDataSourceWithSections<Item, HeaderItem>: BaseViewDataSourceWithSections<Item, HeaderItem>, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return displayedRows.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedRows[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.item(at: indexPath)
        let descriptor = cellDescriptorCreator(item, indexPath)
        registerIfNeeded(reuseIdentifier: descriptor.reuseIdentifier) {
            (_) in

            if let cellNib = descriptor.cellNib {
                tableView.register(cellNib, forCellReuseIdentifier: descriptor.reuseIdentifier)
            } else {
                tableView.register(descriptor.cellClass!, forCellReuseIdentifier: descriptor.reuseIdentifier)
            }
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: descriptor.reuseIdentifier, for: indexPath)
        descriptor.configure(cell)

        return cell
    }
}
