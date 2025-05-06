
///design system bankingCardCarouselOrg
///
import UIKit
import DiiaCommonTypes

public struct BankingCardCarouselBuilder: DSViewBuilderProtocol {
    public static let modelKey = "bankingCardCarouselOrg"
    
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
            cellTypes: [GenericCollectionViewCell.self],
            eventHandler: eventHandler
        )
        view.setupUI()
        
        let bankCards: [BankingCardMlc] = data.items.compactMap({
            return $0.parseValue(forKey: BankingCardBuilder.modelKey)
        })
        if let cellItemId: String = bankCards.first?.id {
            eventHandler(.collectionChange(item: cellItemId))
        }
        
        let paddingBox = BoxView(subview: view).withConstraints(insets: paddingType.defaultCollectionPadding())
        return paddingBox
    }
}

private extension BankingCardCarouselBuilder {
    enum Constants {
        static var cellSize: CGSize {
            let cellWidth = UIScreen.main.bounds.width - 48
            return CGSize(width: cellWidth, height: 208)
        }
    }
}
