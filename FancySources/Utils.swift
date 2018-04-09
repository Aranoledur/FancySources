//
//  Utils.swift
//  FancySources
//
//  Created by Nikolay Ischuk on 01.11.2017.
//  Copyright © 2017 easyverzilla. All rights reserved.
//

import Foundation

public typealias VoidClosure = () -> ()

extension Collection {

    internal subscript(safe i: Index) -> Iterator.Element? {
        return (self.startIndex ..< self.endIndex).contains(i) ? self[i] : nil
    }
}
