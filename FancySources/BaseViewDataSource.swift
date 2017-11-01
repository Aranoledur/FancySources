//
//  BaseViewDataSource.swift
//  888ru
//
//  Created by Nikolay Ischuk on 03.04.17.
//  Copyright © 2017 easyverzilla. All rights reserved.
//

import Foundation

open class BaseViewDataSource<Item>: NSObject {
    
    public var cellDescriptorCreator: ((Item, Int) -> CellDescriptor)!
    
    private var reuseIdentifiers: Set<String> = []
    
    public var displayedRows: [Item] = []
    
    public init(items: [Item]) {
        super.init()
        
        displayedRows = items
    }
    
    internal func registerIfNeeded(reuseIdentifier: String, closure: VoidClosure) {
        if !reuseIdentifiers.contains(reuseIdentifier) {
            closure()
            reuseIdentifiers.insert(reuseIdentifier)
        }
    }
    
    open func reload(newItems: [Item]) {
        displayedRows = newItems
    }
    
    // MARK: - Getting data
    
    open func item(at indexPath: IndexPath) -> Item {
        return displayedRows[indexPath.row]
    }
    
    public final subscript(indexPath: IndexPath) -> Item {
        return item(at: indexPath)
    }
    
    open subscript(safe indexPath: IndexPath) -> Item? {
        if indexPath.row < displayedRows.count {
            return item(at: indexPath)
        }
        return nil
    }
    
    open func remove(at indexPath: IndexPath) {
        displayedRows.remove(at: indexPath.row)
    }
    
    open var isEmpty: Bool {
        return displayedRows.count == 0
    }
}

