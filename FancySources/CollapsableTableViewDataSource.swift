//
//  CollabsableTableViewController.swift
//  888ru
//
//  Created by Nikolay Ischuk on 20.12.16.
//  Copyright © 2016 easyverzilla. All rights reserved.
//

import UIKit

public protocol CollapsableDataModel: class {
    var isCollapsed: Bool { get set }
    var children: [Self] { get }
    var isHeader: Bool { get }
}

public protocol CollapsableTableViewDataSourceDelegate: class {
    func collapsableTableViewDataSource(_ dataSource: Any, willHideCellsAt indexPaths: [IndexPath], at tableView: UITableView)
}

open class CollapsableTableViewDataSource<Item: CollapsableDataModel>: TableViewDataSource<Item> {

    weak var delegate: CollapsableTableViewDataSourceDelegate?

    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Bool {
        return updateTableView(tableView, rowAt: indexPath)
    }

    open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) -> Bool {
        return updateTableView(tableView, rowAt: indexPath)
    }

    private func updateTableView(_ tableView: UITableView, rowAt indexPath: IndexPath) -> Bool {

        let viewModel = item(at: indexPath)
        guard viewModel.isHeader,
            viewModel.children.count > 0 else {
            return false
        }

        let range = indexPath.row+1...indexPath.row+viewModel.children.count
        let indexPaths = range.map {return IndexPath(row: $0, section: indexPath.section)}
        tableView.beginUpdates()
        if viewModel.isCollapsed {
            tableView.insertRows(at: indexPaths, with: .automatic)
        } else {
            delegate?.collapsableTableViewDataSource(self, willHideCellsAt: indexPaths, at: tableView)
            tableView.deleteRows(at: indexPaths, with: .top)
        }
        viewModel.isCollapsed = !viewModel.isCollapsed
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.endUpdates()
        return true
    }

    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        for header in displayedRows {
            count += 1
            if !header.isCollapsed {
                count += header.children.count
            }
        }
        return count
    }

    private func indexesFor(indexPath: IndexPath) -> (headerIndex: Int, childIndex: Int?) {
        var row = 0
        for (index, header) in displayedRows.enumerated() {
            if row == indexPath.row {
                return (index, nil)
            }

            if !header.isCollapsed {
                if indexPath.row > row + header.children.count  {
                    row += header.children.count
                } else {
                    for (childIndex, _) in header.children.enumerated() {
                        row += 1

                        if row == indexPath.row {
                            return (index, childIndex)
                        }
                    }
                }
            }
            
            row += 1
        }

        print("ERROR at \(#function): IndexPath.row is too big")
        return (0, nil)
    }

    open override func item(at indexPath: IndexPath) -> Item {
        let indexes = indexesFor(indexPath: indexPath)
        if let childIndex = indexes.childIndex {
            return displayedRows[indexes.headerIndex].children[childIndex]
        } else {
            return displayedRows[indexes.headerIndex]
        }
    }
}
