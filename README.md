# FancySources
Flexible and abstracted from UIKit data sources

## Usage example

```swift
func didLoadEntities(entities: [SomeEntities]) {
    view?.hideSpinner()
        
    let dataSource = DataSourceType(items: entities)
    view?.fill(with: dataSource)
}

func fill(with dataSource: DataSourceType) {
    dataSource.cellDescriptorCreator = {
        [weak self] item, index in

        return CellDescriptor(nibName: String(describing: SomeGameCell.self), configure: {
            (cell: SomeGameCell) in

            cell.fill(with: item)
            cell.delegate = self
        })
    }
    collectionView.dataSource = dataSource
    collectionView.reloadData()
}
```
