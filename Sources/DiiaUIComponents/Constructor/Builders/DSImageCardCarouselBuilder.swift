
/// design_system_code: halvedCardCarouselOrg

import UIKit
import DiiaCommonTypes

public struct DSImageCardCarouselBuilder: DSViewBuilderProtocol {
    public static let modelKey = "imageCardCarouselOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSImageCardCarouselModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = HorizontalCollectionView()
        view.configure(
            title: nil,
            datasource: DSImageCardCarouselDataSource(
                sourceModel: data,
                fabric: viewFabric ?? DSViewFabric.instance,
                eventHandler: eventHandler),
            cellSize: Constants.cellSize,
            cellTypes: [GenericCollectionViewCell.self]
        )
        view.setupUI(pageControlDotColor: Constants.dotColor)
        
        let paddingBox = BoxView(subview: view).withConstraints(insets: Constants.paddingInsets)
        return paddingBox
    }
}

// MARK: - Data Source
class DSImageCardCarouselDataSource: NSObject, UICollectionViewDataSource {
    private let sourceModel: DSImageCardCarouselModel
    private let eventHandler: (ConstructorItemEvent) -> Void
    private let fabric: DSViewFabric
    
    init(sourceModel: DSImageCardCarouselModel,
         fabric: DSViewFabric,
         eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.sourceModel = sourceModel
        self.fabric = fabric
        self.eventHandler = eventHandler
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let selectedItem = sourceModel.items[indexPath.row]
        let cell: GenericCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        if let view = fabric.makeView(from: AnyCodable.fromEncodable(encodable: selectedItem),
                                      withPadding: .custom(paddings: .zero),
                                      eventHandler: eventHandler) {
            if let item: BankingCardMlc = selectedItem.parseValue(forKey: BankingCardBuilder.modelKey), let itemId = item.id {
                cell.configure(with: view, for: itemId)
            } else {
                cell.configure(with: view)
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sourceModel.items.count
    }
}

// MARK: - Constants
private enum Constants {
    static var cellSize: CGSize {
        let cellWidth = UIScreen.main.bounds.width - 48
        let cellHeight = round(UIScreen.main.bounds.width * 0.51)
        return CGSize(width: cellWidth, height: cellHeight)
    }
    static let paddingInsets = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    static let dotColor = UIColor("#EEF7F1")
}
