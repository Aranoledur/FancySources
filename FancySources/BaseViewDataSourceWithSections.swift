//
//  BaseViewDataSourceWithSections.swift
//  888ru
//
//  Created by Nikolay Ischuk on 05.04.17.
//  Copyright © 2017 easyverzilla. All rights reserved.
//

import Foundation

open class BaseViewDataSourceWithSections<Item, HeaderItem>: NSObject {

    internal var displayedRows: [[Item]] = []

    private var reuseIdentifiers: Set<String> = []

    private var suplementaryReuseIdentifiers: Set<String> = []

    public var cellDescriptorCreator: ((Item, IndexPath) -> CellDescriptor)!

    public var headerDescriptorCreator: ((HeaderItem, Int) -> CellDescriptor)!

    internal var sectionsData: [HeaderItem] {
        didSet {
            assert(sectionsData.count == displayedRows.count)
        }
    }

    init(itemsWithSections: [[Item]], sectionsData: [HeaderItem]) {
        self.sectionsData = sectionsData
        displayedRows = itemsWithSections
        assert(sectionsData.count == itemsWithSections.count)
    }

    func reload(itemsWithSections: [[Item]], sectionsData: [HeaderItem]) {
        displayedRows = itemsWithSections
        self.sectionsData = sectionsData
    }

    func registerIfNeeded(reuseIdentifier: String, closure: (Void) -> Void) {
        if !reuseIdentifiers.contains(reuseIdentifier) {
            closure()
            reuseIdentifiers.insert(reuseIdentifier)
        }
    }

    func registerIfNeededSupplementary(reuseIdentifier: String, closure: (Void) -> Void) {
        if !suplementaryReuseIdentifiers.contains(reuseIdentifier) {
            closure()
            suplementaryReuseIdentifiers.insert(reuseIdentifier)
        }
    }

    open func sectionData(for section: Int) -> HeaderItem {
        return sectionsData[section]
    }

    open func item(at indexPath: IndexPath) -> Item {
        return displayedRows[indexPath.section][indexPath.row]
    }

    final subscript(indexPath: IndexPath) -> Item {
        return item(at: indexPath)
    }

    final subscript(safe indexPath: IndexPath) -> Item? {
        if indexPath.section < displayedRows.count,
            indexPath.row < displayedRows[indexPath.section].count {
            return item(at: indexPath)
        }
        return nil
    }
}
