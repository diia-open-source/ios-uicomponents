import UIKit
import DiiaCommonTypes

///design system: bankingCardCarouselOrg
public struct BankingCardCarouselBuilder: DSViewBuilderProtocol {
    public let modelKey = "bankingCardCarouselOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSImageCardCarouselModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
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
        view.setupUI(pageControlDotColor: Constants.dotColor)
        
        let bankCards: [BankingCardMlc] = data.items.compactMap({
            return $0.parseValue(forKey: "bankingCardMlc")
        })
        if let cellItemId: String = bankCards.first?.id {
            eventHandler(.collectionChange(item: cellItemId))
        }
        
        let paddingBox = BoxView(subview: view).withConstraints(insets: paddingType.defaultCollectionPadding(object: object, modelKey: modelKey))
        return paddingBox
    }
}

private extension BankingCardCarouselBuilder {
    enum Constants {
        static var cellSize: CGSize {
            let cellWidth = UIScreen.main.bounds.width - 48
            return CGSize(width: cellWidth, height: 208)
        }
        
        static let dotColor = UIColor("#EEF7F1")
    }
}

extension BankingCardCarouselBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let bankCardMock = BankingCardBuilder().makeMockModel()
        
        let model = DSImageCardCarouselModel(
            componentId: "componentId",
            dotNavigationAtm: DSDotNavigationModel(count: 2),
            items: [bankCardMock, bankCardMock]
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
