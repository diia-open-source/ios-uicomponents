
/// design_system_code: imageCardCarouselOrg

import UIKit
import DiiaCommonTypes

public struct DSImageCardCarouselBuilder: DSViewBuilderProtocol {
    public let modelKey = "imageCardCarouselOrg"

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
        view.setupUI(pageControlDotColor: Constants.dotColor)

        let paddingBox = BoxView(subview: view).withConstraints(insets: Constants.paddingInsets)
        return paddingBox
    }
}

extension DSImageCardCarouselBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let imageCard = DSImageCardMlc(
            imageCardMlc: DSImageCardModel(
                componentId: "componentId",
                image: "https://mockurl.com/image.png",
                label: "Mock Image Card",
                imageAltText: "Mock image description",
                iconRight: "home",
                action: .mock
            )
        )

        let model = DSImageCardCarouselModel(
            componentId: "componentId",
            dotNavigationAtm: DSDotNavigationModel(count: 1),
            items: [AnyCodable.fromEncodable(encodable: imageCard)]
        )

        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}

// MARK: - Data Source
final class DSImageCardCarouselDataSource: NSObject, UICollectionViewDataSource {
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
        let item = sourceModel.items[indexPath.row]
        let cell: GenericCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        if let view = fabric.makeView(from: AnyCodable.fromEncodable(encodable: item),
                                      withPadding: .fixed(paddings: .zero),
                                      eventHandler: eventHandler) {
            let itemId = item.values().first?.getValue(forKey: "id")?.stringValue()
            cell.configure(with: view, for: itemId)
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
