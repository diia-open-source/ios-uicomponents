
import UIKit
import DiiaCommonTypes

// MARK: - Data Source
class PhotoCardDataSource: NSObject, UICollectionViewDataSource {
    private let sourceModel: DSImageCardCarouselModel
    private let eventHandler: (ConstructorItemEvent) -> Void
    private let fabric: DSViewFabric
    
    private let bufferItems = 3
    
    init(sourceModel: DSImageCardCarouselModel,
         fabric: DSViewFabric,
         eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.sourceModel = sourceModel
        self.fabric = fabric
        self.eventHandler = eventHandler
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = sourceModel.items[indexPath.row % sourceModel.items.count]
        let cell: GenericCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        if let view = fabric.makeView(
            from: AnyCodable.fromEncodable(encodable: item),
            withPadding: .fixed(paddings: .zero),
            eventHandler: eventHandler) {
            cell.configure(with: view)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sourceModel.items.count + bufferItems
    }
}
