//
//  CollectionViewDataSourceWithSections.swift
//  888ru
//
//  Created by Nikolay Ischuk on 03.04.17.
//  Copyright © 2017 easyverzilla. All rights reserved.
//

import Foundation
import UIKit

open class CollectionViewDataSourceWithSections<Item, HeaderItem>: BaseViewDataSourceWithSections<Item, HeaderItem>, UICollectionViewDataSource {

    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return displayedRows.count
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedRows[section].count
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        registerIfNeeded(reuseIdentifier: SharedData.fakeCellIdentifier) {
            collectionView.fs_registerFakeCell()
        }
        guard let item = self.item(at: indexPath) else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: SharedData.fakeCellIdentifier, for: indexPath)
        }

        let descriptor = cellDescriptorCreator(item, indexPath)
        registerIfNeeded(reuseIdentifier: descriptor.reuseIdentifier) {
            collectionView.registerCell(descriptor)
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptor.reuseIdentifier, for: indexPath)
        descriptor.configure(cell)

        return cell
    }

    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        registerIfNeeded(reuseIdentifier: SharedData.fakeCellIdentifier) {
            collectionView.fs_registerFakeSupplementary(of: kind)
        }
        guard let item = sectionData(for: indexPath.section) else {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: SharedData.fakeCellIdentifier,
                                                                   for: indexPath)
        }
        
        let descriptor = headerDescriptorCreator(item, indexPath.section)
        registerIfNeededSupplementary(reuseIdentifier: descriptor.reuseIdentifier) {
            collectionView.registerSupplementary(descriptor, kind: kind)
        }

        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: descriptor.reuseIdentifier, for: indexPath)
        descriptor.configure(view)
        
        return view
    }
}
