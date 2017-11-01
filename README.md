# FancySources
Flexible, generic and abstracted from UIKit data sources

## Usage example

```swift
typealias DataSourceType = CollectionViewDataSource

func didLoadEntities(entities: [SomeEntities]) {        
    let dataSource = DataSourceType(items: entities)
    fill(with: dataSource)
}

func fill(with dataSource: DataSourceType) {
    dataSource.cellDescriptorCreator = {
        [weak self] item, index in

        if item.isGame {
            return CellDescriptor(nibName: String(describing: SomeGameCell.self), configure: {
                (cell: SomeGameCell) in

                cell.fill(with: item)
                cell.delegate = self
            })
        } else { //item.isChampionship
            return CellDescriptor(reuseIdentifier: String(describing: SomeChampionshipCell.self), configure: {
                (cell: SomeGameCell) in

                cell.fill(with: item)
                cell.delegate = self
            })
        }
    }
    collectionView.dataSource = dataSource
    collectionView.reloadData()
}
```
