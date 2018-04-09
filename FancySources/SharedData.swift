//
//  SharedData.swift
//  SystemUtils
//
//  Created by Nikolay Ischuk on 09.04.2018.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import Foundation
import UIKit

internal struct SharedData {
    static let fakeCellIdentifier = "FancySources.FakeCell"
}

extension UITableView {
    internal func fs_registerFakeCell() {
        register(UITableViewCell.self, forCellReuseIdentifier: SharedData.fakeCellIdentifier)
    }
}

extension UICollectionView {
    internal func fs_registerFakeCell() {
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: SharedData.fakeCellIdentifier)
    }

    internal func fs_registerFakeSupplementary(of kind: String) {
        register(UICollectionReusableView.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: SharedData.fakeCellIdentifier)
    }
}
