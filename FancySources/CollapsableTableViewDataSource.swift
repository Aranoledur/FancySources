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
        result.reserveCapacity(children.count * 2)
        if isHeader &&
            !collapseClosure(self) {
            for i in children.indices {
                result.append(children[i])
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
    
    private func toggleCollapse<Item: CollapsableDataModel>(_ item: Item) {
        if collapseInfo.contains(item.hashString) {
            collapseInfo.remove(item.hashString)
        } else {
            collapseInfo.insert(item.hashString)
        }
    }

    public func toggleCollapse<Item: CollapsableDataModel>(_ item: Item, section: Int) {
        toggleCollapse(item)
        visibleChildren.removeValue(forKey: section)
    }
    
    @discardableResult
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Bool {
        return updateTableView(tableView, rowAt: indexPath)
    }
    
    @discardableResult
    open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) -> Bool {
        return updateTableView(tableView, rowAt: indexPath)
    }
    
    private func updateTableView(_ tableView: UITableView, rowAt indexPath: IndexPath) -> Bool {
        
        guard let viewModel = item(at: indexPath),
            viewModel.isHeader,
            viewModel.children.count > 0 else {
                return false
        }
        
        let neededChildrenCount: Int
        let neededVisibleChildren: [Item]
        let wasCollapsed = isCollapsed(viewModel)
        if wasCollapsed {
            toggleCollapse(viewModel)
            neededVisibleChildren = viewModel.visibleChildren(isCollapsed)
            neededChildrenCount = neededVisibleChildren.count
        } else {
            neededVisibleChildren = viewModel.visibleChildren(isCollapsed)
            neededChildrenCount = neededVisibleChildren.count
            toggleCollapse(viewModel)
        }
        let range = indexPath.row+1...indexPath.row+neededChildrenCount
        let indexPaths = range.map { return IndexPath(row: $0, section: indexPath.section) }
        tableView.beginUpdates()
        if wasCollapsed {
            tableView.insertRows(at: indexPaths, with: (hasAnimation ? .automatic : .none))
            visibleChildren[indexPath.section]?.insert(contentsOf: neededVisibleChildren,
                                                       at: indexPath.row)
        } else {
            delegate?.collapsableTableViewDataSource(self, willHideCellsAt: indexPaths, at: tableView)
            tableView.deleteRows(at: indexPaths, with: (hasAnimation ? .top : .none))
            let removeSubrange = indexPath.row...indexPath.row+neededChildrenCount-1
            visibleChildren[indexPath.section]?.removeSubrange(removeSubrange)
        }
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.endUpdates()
        return true
    }

    open override func numberOfSections(in tableView: UITableView) -> Int {
        return displayedRows.count
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleChildren(for: section).count + 1
    }
    
    override open func item(at indexPath: IndexPath) -> Item? {

        let section = indexPath.section
        if indexPath.row == 0 {
            return displayedRows[safe: section]
        }
        return visibleChildren(for: section)[safe: indexPath.row - 1]
    }

    open override func reload(newItems: [Item]) {
        super.reload(newItems: newItems)
        visibleChildren.removeAll()
    }

    public func recalculateChildren(forSection section: Int) {
        visibleChildren.removeValue(forKey: section)
    }

    public func recalculateChildren() {
        visibleChildren.removeAll()
    }

    private var visibleChildren: [Int: [Item]] = [:]

    public func visibleChildren(for section: Int) -> [Item] {
        if visibleChildren[section] == nil {
            visibleChildren[section] = displayedRows[section].visibleChildren(isCollapsed)
        }
        return visibleChildren[section] ?? []
    }
}
