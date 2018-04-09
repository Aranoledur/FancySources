//
//  CollectionViewDataSource.swift
//  888ru
//
//  Created by Nikolay Ischuk on 03.04.17.
//  Copyright © 2017 easyverzilla. All rights reserved.
//

import Foundation
import UIKit

open class CollectionViewDataSource<Item>: BaseViewDataSource<Item>, UICollectionViewDataSource {

    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedRows.count
    }

    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        fatalError()
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        registerIfNeeded(reuseIdentifier: SharedData.fakeCellIdentifier) {
            collectionView.fs_registerFakeCell()
        }
        guard let item = self.item(at: indexPath) else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: SharedData.fakeCellIdentifier, for: indexPath)
        }

        let descriptor = cellDescriptorCreator(item, indexPath.row)
        registerIfNeeded(reuseIdentifier: descriptor.reuseIdentifier) {

            collectionView.registerCell(descriptor)
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptor.reuseIdentifier, for: indexPath)
        descriptor.configure(cell)

        return cell
    }
}
