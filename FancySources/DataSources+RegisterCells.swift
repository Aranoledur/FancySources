//
//  DataSources+RegisterCells.swift
//  FancySources
//
//  Created by Nikolay Ischuk on 01.11.2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func registerCell(_ descriptor: CellDescriptor) {
        switch descriptor.type {
        case .cellNib(let cellNib):
            register(cellNib, forCellReuseIdentifier: descriptor.reuseIdentifier)
        case .cellClass(let cellType):
            register(cellType, forCellReuseIdentifier: descriptor.reuseIdentifier)
        case .prototypeCell:
            break
        }
    }
}

extension UICollectionView {
    func registerCell(_ descriptor: CellDescriptor) {
        switch descriptor.type {
        case .cellNib(let cellNib):
            register(cellNib, forCellWithReuseIdentifier: descriptor.reuseIdentifier)
        case .cellClass(let cellType):
            register(cellType, forCellWithReuseIdentifier: descriptor.reuseIdentifier)
        case .prototypeCell:
            break
        }
    }
    
    func registerSupplementary(_ descriptor: CellDescriptor, kind: String) {
        switch descriptor.type {
        case .cellNib(let cellNib):
            register(cellNib, forSupplementaryViewOfKind: kind, withReuseIdentifier: descriptor.reuseIdentifier)
        case .cellClass(let cellType):
            register(cellType, forSupplementaryViewOfKind: kind, withReuseIdentifier: descriptor.reuseIdentifier)
        case .prototypeCell:
            break
        }
    }
}
