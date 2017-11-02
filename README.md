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

                cell.setChampionship(item)
            })
        }
    }
    collectionView.dataSource = dataSource
    collectionView.reloadData()
}
```

## Flexible
E.g. server told you to reload item with some ID. You can implement it like this
```swift
extension BaseViewDataSource where Item: SomeType {
    func update(_ newItem: Item) -> IndexPath {
        //find item with newItem.id, update it using new data and return IndexPath
    }
}

func didUpdateItem(_ updatedItem: Item) {
    let path = dataSource.update(updatedItem)
    view.updatePath(path)
}
```
And because this method implemented for base class, all subclasses will have it too. So you don't have to rewrite or copy/past it before switching from TableViewDataSource to CollectionViewDataSource or your own subclass. Even if you have 2-3 views in your project that shows same data, but in different style, still you can use this method.

## Generic
Interface for base class is `class BaseViewDataSourceWithSections<Item, HeaderItem> {}`, so you can put any data you want to this data sources. Even some wrappers or enums that can contains various data.

## Abstracted from UIKit
No one is implementing UITableViewDelegate/UICollectionViewDelegate here. It's up to you, so you can do it in your own way. Data sources only care about data, visual implementation is incapsulated to `descriptorCreator`s. So when you deal with data source you don't need to know how this data is displayed, you have to know only how items are structured. Visual part (cells) can be implemented by someone else, another class or another developer.

## Easy to use
20 lines of code from usage example is the only thing you have to write to fill table or collection view. 
