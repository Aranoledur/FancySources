//
//  CollabsableTableViewController.swift
//  888ru
//
//  Created by Nikolay Ischuk on 20.12.16.
//  Copyright © 2016 easyverzilla. All rights reserved.
//


import UIKit

public protocol CollapsableDataModel: class {
    var children: [Self] { get }
    var isHeader: Bool { get }
    var hashString: String { get }
}

extension CollapsableDataModel {
    public func visibleChildrenCount(_ collapseClosure: (Self) -> Bool) -> Int {
        return visibleChildren(collapseClosure).count
    }

    public func visibleChildren(_ collapseClosure: (Self) -> Bool) -> [Self] {
        var result: [Self] = []
        if isHeader &&
            !collapseClosure(self) {
            result.append(contentsOf: children)
            for i in children.indices {
                result.append(contentsOf: children[i].visibleChildren(collapseClosure))
            }
        }

        return result
    }
}

public protocol CollapsableTableViewDataSourceDelegate: class {
    func collapsableTableViewDataSource(_ dataSource: Any, willHideCellsAt indexPaths: [IndexPath], at tableView: UITableView)
}

open class CollapsableTableViewDataSource<Item: CollapsableDataModel>: TableViewDataSource<Item> {
    
    public weak var delegate: CollapsableTableViewDataSourceDelegate?
    
    private(set) var collapseInfo: Set<String> = [] //set of hash strings
    open var collapsedByDefault: Bool
    public var hasAnimation: Bool = false
    
    public init(items: [Item], collapsedByDefault: Bool) {
        self.collapsedByDefault = collapsedByDefault
        super.init(items: items)
    }
    
    open func isCollapsed<Item: CollapsableDataModel>(_ item: Item) -> Bool {
        if collapsedByDefault {
            return !collapseInfo.contains(item.hashString)
        } else {
            return collapseInfo.contains(item.hashString)
        }
    }
    
    open func toggleCollapse<Item: CollapsableDataModel>(_ item: Item) {
        if collapseInfo.contains(item.hashString) {
            collapseInfo.remove(item.hashString)
        } else {
            collapseInfo.insert(item.hashString)
        }
    }
    
    @discardableResult
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Bool {
        return updateTableView(tableView, rowAt: indexPath)
    }
    
    @discardableResult
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) -> Bool {
        return updateTableView(tableView, rowAt: indexPath)
    }
    
    private func updateTableView(_ tableView: UITableView, rowAt indexPath: IndexPath) -> Bool {
        
        let viewModel = item(at: indexPath)
        guard viewModel.isHeader,
            viewModel.children.count > 0 else {
                return false
        }
        
        let neededChildrenCount: Int
        if isCollapsed(viewModel) {
            neededChildrenCount = viewModel.children.count + viewModel.children.reduce(0, { $0 + $1.visibleChildrenCount(isCollapsed) })
        } else {
            neededChildrenCount = viewModel.visibleChildrenCount(isCollapsed)
        }
        let range = indexPath.row+1...indexPath.row+neededChildrenCount
        let indexPaths = range.map { return IndexPath(row: $0, section: indexPath.section) }
        tableView.beginUpdates()
        if isCollapsed(viewModel) {
            tableView.insertRows(at: indexPaths, with: (hasAnimation ? .automatic : .none))
        } else {
            delegate?.collapsableTableViewDataSource(self, willHideCellsAt: indexPaths, at: tableView)
            tableView.deleteRows(at: indexPaths, with: (hasAnimation ? .top : .none))
        }
        toggleCollapse(viewModel)
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.endUpdates()
        return true
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        for i in displayedRows.indices {
            count += 1
            count += displayedRows[i].visibleChildrenCount(isCollapsed)
        }
        return count
    }
    
    open func element(in items: [Item], indexPath: IndexPath, row: inout Int) -> Item? {
        
        for i in items.indices {
            if row == indexPath.row {
                return items[i]
            }
            
            row += 1
            
            if items[i].isHeader &&
                !isCollapsed(items[i]) {
                if let element = element(in: items[i].children, indexPath: indexPath, row: &row) {
                    return element
                }
            }
        }
        
        return nil
    }
    
    override open func item(at indexPath: IndexPath) -> Item {
        
        var row = 0
        return element(in: displayedRows, indexPath: indexPath, row: &row)!
    }
    
    override open func reload(newItems: [Item]) {
        super.reload(newItems: newItems)
    }
}
