#
#  Be sure to run `pod spec lint FancySources.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "FancySources"
  s.version      = "1.0.1"
  s.summary      = "Flexible, generic and abstracted from UIKit data sources."
  s.description  = "FancySources

Flexible, generic and abstracted from UIKit data sources

Usage example

typealias DataSourceType = CollectionViewDataSource

func didLoadEntities(entities: [SomeEntities]) {        
    let dataSource = DataSourceType(items: entities)
    fill(with: dataSource)
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
}"
  s.homepage     = "https://github.com/Aranoledur/FancySources"
  s.license      = { :type => 'MIT', :file => "LICENSE" }
  s.author       = { "Nikolay Ischuk" => "nk13.666@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/Aranoledur/FancySources.git", :tag => "v#{s.version}" }
  s.source_files  = "FancySources", "FancySources/**/*.{h,m,swift}"
  s.exclude_files = "FancySources/Exclude"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4' }

end
