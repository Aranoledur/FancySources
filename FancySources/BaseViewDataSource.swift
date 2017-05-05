//
//  BaseViewDataSource.swift
//  888ru
//
//  Created by Nikolay Ischuk on 03.04.17.
//  Copyright © 2017 easyverzilla. All rights reserved.
//

import Foundation
import UIKit

public struct CellDescriptor {
    let storyboardBasedCell: Bool
    let cellNib: UINib?
    let cellClass: UIView.Type?
    let reuseIdentifier: String
    let configure: (UIView) -> Void

    public init<Cell>(reuseIdentifier: String, cellNib: UINib, configure: @escaping (Cell) -> Void) {
        self.storyboardBasedCell = false
        self.cellNib = cellNib
        self.reuseIdentifier = reuseIdentifier
        self.configure = {
            cell in

            configure(cell as! Cell)
        }
        cellClass = nil
    }

    public init<Cell>(nibName: String, configure: @escaping (Cell) -> Void) {
        let cellNib = UINib(nibName: nibName, bundle: nil)
        let reuseIdentifier = nibName
        self.init(reuseIdentifier: reuseIdentifier, cellNib: cellNib, configure: configure)
    }

    public init<Cell>(reuseIdentifier: String, cellClass: UIView.Type, configure: @escaping (Cell) -> Void) {
        self.storyboardBasedCell = false
        self.cellClass = cellClass
        self.reuseIdentifier = reuseIdentifier
        self.configure = {
            cell in

            configure(cell as! Cell)
        }
        self.cellNib = nil
    }

    public init<Cell: UITableViewCell>(prototypeCellReuseIdentifier: String, configure: @escaping (Cell) -> Void) {
        self.storyboardBasedCell = true
        self.reuseIdentifier = prototypeCellReuseIdentifier
        self.configure = {
            cell in
            
            configure(cell as! Cell)
        }
        self.cellNib = nil
        self.cellClass = nil
    }

}

open class BaseViewDataSource<Item>: NSObject {
    public var cellDescriptorCreator: ((Item, Int) -> CellDescriptor)!
    private var reuseIdentifiers: Set<String> = []
    var displayedRows: [Item] = []

    public init(items: [Item]) {
        super.init()

        displayedRows = items
    }

    func registerIfNeeded(reuseIdentifier: String, closure: (Void) -> Void) {
        if !reuseIdentifiers.contains(reuseIdentifier) {
            closure()
            reuseIdentifiers.insert(reuseIdentifier)
        }
    }

    func reload(newItems: [Item]) {
        displayedRows = newItems
    }

    // MARK: - Getting data

    open func item(at indexPath: IndexPath) -> Item {
        return displayedRows[indexPath.row]
    }

    final subscript(indexPath: IndexPath) -> Item {
        return item(at: indexPath)
    }

    final subscript(safe indexPath: IndexPath) -> Item? {
        if indexPath.row < displayedRows.count {
            return item(at: indexPath)
        }
        return nil
    }

    final func remove(at indexPath: IndexPath) {
        displayedRows.remove(at: indexPath.row)
    }

    open var isEmpty: Bool {
        return displayedRows.count == 0
    }
}
