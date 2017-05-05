//
//  CollectionViewDataSource.swift
//  888ru
//
//  Created by Nikolay Ischuk on 03.04.17.
//  Copyright © 2017 easyverzilla. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewDataSource<Item>: BaseViewDataSource<Item>, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedRows.count
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        fatalError()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.item(at: indexPath)
        let descriptor = cellDescriptorCreator(item, indexPath.row)
        registerIfNeeded(reuseIdentifier: descriptor.reuseIdentifier) {
            (_) in

            if let cellNib = descriptor.cellNib {
                collectionView.register(cellNib, forCellWithReuseIdentifier: descriptor.reuseIdentifier)
            } else {
                collectionView.register(descriptor.cellClass!, forCellWithReuseIdentifier: descriptor.reuseIdentifier)
            }
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptor.reuseIdentifier, for: indexPath)
        descriptor.configure(cell)

        return cell
    }
}
