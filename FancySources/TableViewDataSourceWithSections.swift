//
//  TableViewDataSourceWithSections.swift
//  888ru
//
//  Created by Nikolay Ischuk on 07.02.17.
//  Copyright © 2017 easyverzilla. All rights reserved.
//

import Foundation
import UIKit

open class TableViewDataSourceWithSections<Item, HeaderItem>: BaseViewDataSourceWithSections<Item, HeaderItem>, UITableViewDataSource {

    open func numberOfSections(in tableView: UITableView) -> Int {
        return displayedRows.count
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedRows[section].count
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        registerIfNeeded(reuseIdentifier: SharedData.fakeCellIdentifier) {
            tableView.fs_registerFakeCell()
        }
        guard let item = self.item(at: indexPath) else {
            return tableView.dequeueReusableCell(withIdentifier: SharedData.fakeCellIdentifier, for: indexPath)
        }

        let descriptor = cellDescriptorCreator(item, indexPath)
        registerIfNeeded(reuseIdentifier: descriptor.reuseIdentifier) {
            tableView.registerCell(descriptor)
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: descriptor.reuseIdentifier, for: indexPath)
        descriptor.configure(cell)

        return cell
    }
}
