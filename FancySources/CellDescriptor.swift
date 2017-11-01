//
//  CellDescriptor.swift
//  888ru
//
//  Created by Nikolay Ischuk on 12.05.17.
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
            
            // swiftlint:disable:next force_cast
            configure(cell as! Cell)
        }
        cellClass = nil
    }
    
    public init<Cell: UIView>(nibName: String, configure: @escaping (Cell) -> Void) {
        let cellNib = UINib(nibName: nibName, bundle: nil)
        let reuseIdentifier = nibName
        self.init(reuseIdentifier: reuseIdentifier, cellNib: cellNib, configure: configure)
    }
    
    public init<Cell: UIView>(reuseIdentifier: String, configure: @escaping (Cell) -> Void) {
        self.storyboardBasedCell = false
        self.cellClass = Cell.self
        self.reuseIdentifier = reuseIdentifier
        self.configure = {
            cell in
            
            // swiftlint:disable:next force_cast
            configure(cell as! Cell)
        }
        self.cellNib = nil
    }
    
    public init<Cell: UIView>(prototypeCellReuseIdentifier: String, configure: @escaping (Cell) -> Void) {
        self.storyboardBasedCell = true
        self.reuseIdentifier = prototypeCellReuseIdentifier
        self.configure = {
            cell in
            
            // swiftlint:disable:next force_cast
            configure(cell as! Cell)
        }
        self.cellNib = nil
        self.cellClass = nil
    }
    
}

