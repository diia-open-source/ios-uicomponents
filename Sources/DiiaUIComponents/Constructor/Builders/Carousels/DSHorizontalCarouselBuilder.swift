
import UIKit
import DiiaCommonTypes

/// design_system_code: verticalCardCarouselOrg
public struct DSHorizontalCarouselBuilder: DSViewBuilderProtocol {
    public let modelKey = "verticalCardCarouselOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSVerticalCardCarouselModel = object.parseValue(forKey: self.modelKey) else { return nil }
                
        let configurator = DSHorizontalCarouselConfigurator(model: data, eventHandler: eventHandler)
        
        let collectionView = DSCollectionCarouselView()
        collectionView.configure(
            dataSource: configurator,
            cellSize: Constants.cellSize,
            cellTypes: [DSVerticalCardCell.self]
        )
        collectionView.setupUI(
            scrollDirection: .horizontal,
            sectionInset: Constants.sectionInsets
        )
        
        let paddingBox = BoxView(subview: collectionView).withConstraints(insets: Constants.paddingInsets)
        return paddingBox
    }
}

// MARK: - Carousel Configurator
class DSHorizontalCarouselConfigurator: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private let model: DSVerticalCardCarouselModel
    private let eventHandler: (ConstructorItemEvent) -> Void
    
    init(model: DSVerticalCardCarouselModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.model = model
        self.eventHandler = eventHandler
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DSVerticalCardCell = collectionView.dequeueReusableCell(for: indexPath)
        let item = model.items[indexPath.row]
        cell.configure(with: .init(model: item.verticalCardMlc) { [weak self] in
            guard let action = item.verticalCardMlc.action else { return }
            self?.eventHandler(.action(action))
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Constants.cellSize
    }
}

extension DSHorizontalCarouselBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let carouselItem1 = DSVerticalCardCarouselItem(verticalCardMlc: DSVerticalCardCarouselItemModel(
            id: "card1",
            title: "Vertical Card 1",
            image: "https://example.com/image1.jpg",
            badgeCounterAtm: DSBadgeCounterModel(count: 5),
            action: DSActionParameter.mock,
            imageAltText: "Image description"
        ))
        let carouselItem2 = DSVerticalCardCarouselItem(verticalCardMlc: DSVerticalCardCarouselItemModel(
            id: "card2",
            title: "Vertical Card 2", 
            image: "https://example.com/image2.jpg",
            badgeCounterAtm: DSBadgeCounterModel(count: 0),
            action: nil,
            imageAltText: "Second image description"
        ))
        
        let model = DSVerticalCardCarouselModel(items: [carouselItem1, carouselItem2])
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}

private enum Constants {
    static var cellSize: CGSize {
        let cellHeight = UIScreen.main.bounds.width * 0.77
        let cellWidth = round(cellHeight * 0.77)
        return CGSize(width: cellWidth, height: cellHeight)
    }
    static let paddingInsets = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    static let sectionInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
}
