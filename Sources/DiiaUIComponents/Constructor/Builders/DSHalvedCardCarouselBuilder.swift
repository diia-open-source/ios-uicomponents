import UIKit
import DiiaCommonTypes

/// design_system_code: halvedCardCarouselOrg
public struct DSHalvedCardCarouselBuilder: DSViewBuilderProtocol {
    public static let modelKey = "halvedCardCarouselOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSHalvedCardCarouselModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let dataSource = DSHalvedCardCarouselDataSource(sourceModel: data, eventHandler: eventHandler)
        
        let view = HorizontalCollectionView()
        view.configure(
            title: nil,
            datasource: dataSource,
            accessibilityDescridable: dataSource,
            cellSize: Constants.cellSize,
            cellTypes: [DSHalvedCardCell.self, DSIconCardCell.self]
        )
        view.setupUI(pageControlDotColor: Constants.dotColor)
        
        let paddingBox = BoxView(subview: view).withConstraints(insets: Constants.paddingInsets)
        return paddingBox
    }
}

// MARK: - Data Source
class DSHalvedCardCarouselDataSource: NSObject, UICollectionViewDataSource {
    private let sourceModel: DSHalvedCardCarouselModel
    private let eventHandler: (ConstructorItemEvent) -> Void
    
    init(sourceModel: DSHalvedCardCarouselModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.sourceModel = sourceModel
        self.eventHandler = eventHandler
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let selectedItem = sourceModel.items[indexPath.row]
        if let halvedCard = selectedItem.halvedCardMlc {
            let cell: DSHalvedCardCell = collectionView.dequeueReusableCell(for: indexPath)
            let cellVM = DSHalvedCardViewModel(
                id: halvedCard.action?.resource ?? "",
                imageURL: halvedCard.image,
                label: halvedCard.label,
                title: halvedCard.title)
            cellVM.clickAction = { [weak self] in
                guard let action = halvedCard.action,
                      collectionView.isCellFullyVisible(at: indexPath)
                else { return }
                self?.eventHandler(.action(action))
            }
            cell.configure(with: cellVM)
            return cell
        }
        if let iconCard = selectedItem.iconCardMlc {
            let cell: DSIconCardCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(with: .init(model: iconCard) { [weak self] in
                guard let action = iconCard.action,
                      collectionView.isCellFullyVisible(at: indexPath)
                else { return }
                self?.eventHandler(.action(action))
            })
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sourceModel.items.count
    }
}

// MARK:
extension DSHalvedCardCarouselDataSource: AccessibilityDescridable {
    var accessibilityDescriptions: [String]? {
        let descriptions = sourceModel.items.map { carouselItem in
            if let news = carouselItem.halvedCardMlc {
                return news.accessibilityDescription ?? news.label + news.title
            }
            
            if let iconCardMlc = carouselItem.iconCardMlc {
                return iconCardMlc.accessibilityDescription ?? iconCardMlc.label
            }
            
            return ""
        }
        
        return descriptions.isEmpty ? nil : descriptions
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
