//
//  BaseViewDataSourceWithSections.swift
//  888ru
//
//  Created by Nikolay Ischuk on 05.04.17.
//  Copyright © 2017 easyverzilla. All rights reserved.
//

import Foundation

open class BaseViewDataSourceWithSections<Item, HeaderItem>: NSObject {

    public var displayedRows: [[Item]] = []

    private var reuseIdentifiers: Set<String> = []

    private var suplementaryReuseIdentifiers: Set<String> = []

    public var cellDescriptorCreator: ((Item, IndexPath) -> CellDescriptor)!

    public var headerDescriptorCreator: ((HeaderItem, Int) -> CellDescriptor)!

    public var sectionsData: [HeaderItem] {
        didSet {
            assert(sectionsData.count == displayedRows.count)
        }
    }

    public init(itemsWithSections: [[Item]], sectionsData: [HeaderItem]) {
        self.sectionsData = sectionsData
        displayedRows = itemsWithSections
        assert(sectionsData.count == itemsWithSections.count)
    }

    public func reload(itemsWithSections: [[Item]], sectionsData: [HeaderItem]) {
        displayedRows = itemsWithSections
        self.sectionsData = sectionsData
    }

    internal func registerIfNeeded(reuseIdentifier: String, closure: VoidClosure) {
        if !reuseIdentifiers.contains(reuseIdentifier) {
            closure()
            reuseIdentifiers.insert(reuseIdentifier)
        }
    }

    internal func registerIfNeededSupplementary(reuseIdentifier: String, closure: VoidClosure) {
        if !suplementaryReuseIdentifiers.contains(reuseIdentifier) {
            closure()
            suplementaryReuseIdentifiers.insert(reuseIdentifier)
        }
    }

    open func sectionData(for section: Int) -> HeaderItem? {
        return sectionsData[safe: section]
    }

    open func item(at indexPath: IndexPath) -> Item? {
        return displayedRows[safe: indexPath.section]?[safe: indexPath.row]
    }

    public final subscript(indexPath: IndexPath) -> Item? {
        return item(at: indexPath)
    }
}
