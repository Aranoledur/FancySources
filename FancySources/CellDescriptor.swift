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
    
    public enum DescriptorType {
        case cellNib(UINib)
        case cellClass(UIView.Type)
        case prototypeReuseIdentifier
    }
    
    let type: DescriptorType
    let reuseIdentifier: String
    let configure: (UIView) -> Void
    
    public init<Cell>(reuseIdentifier: String, cellNib: UINib, configure: @escaping (Cell) -> Void) {
        self.type = .cellNib(cellNib)
        self.reuseIdentifier = reuseIdentifier
        self.configure = {
            cell in
            
            // swiftlint:disable:next force_cast
            configure(cell as! Cell)
        }
    }
    
    public init<Cell: UIView>(nibName: String, configure: @escaping (Cell) -> Void) {
        let cellNib = UINib(nibName: nibName, bundle: nil)
        let reuseIdentifier = nibName
        self.init(reuseIdentifier: reuseIdentifier, cellNib: cellNib, configure: configure)
    }
    
    public init<Cell: UIView>(reuseIdentifier: String, configure: @escaping (Cell) -> Void) {
        self.type = .cellClass(Cell.self)
        self.reuseIdentifier = reuseIdentifier
        self.configure = {
            cell in
            
            // swiftlint:disable:next force_cast
            configure(cell as! Cell)
        }
    }
    
    public init<Cell: UIView>(prototypeCellReuseIdentifier: String, configure: @escaping (Cell) -> Void) {
        self.type = .prototypeReuseIdentifier
        self.reuseIdentifier = prototypeCellReuseIdentifier
        self.configure = {
            cell in
            
            // swiftlint:disable:next force_cast
            configure(cell as! Cell)
        }
    }
}

