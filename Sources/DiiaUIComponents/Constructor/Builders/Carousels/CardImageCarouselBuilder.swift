

///design system cardImageCarouselOrg
///
import UIKit
import DiiaCommonTypes

public struct CardImageCarouselBuilder: DSViewBuilderProtocol {
    public let modelKey = "cardImageCarouselOrg"
    
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
            cellTypes: [GenericCollectionViewCell.self]
        )
        
        let paddingBox = BoxView(subview: view).withConstraints(
            insets: paddingType.defaultCollectionPadding(object: object, modelKey: modelKey)
        )
        return paddingBox
    }
}


private extension CardImageCarouselBuilder {
    enum Constants {
        static var cellSize: CGSize {
            let cellWidth = UIScreen.main.bounds.width - 36
            return CGSize(width: cellWidth, height: cellWidth / 1.2)
        }
    }
}

extension CardImageCarouselBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let bankCardMock = CardImageMlcBuilder().makeMockModel()
        
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
