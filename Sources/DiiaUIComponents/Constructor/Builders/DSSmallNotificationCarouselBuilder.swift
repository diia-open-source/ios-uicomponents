
import UIKit
import DiiaCommonTypes

/// design_system_code: smallNotificationCarouselOrg
public struct DSSmallNotificationCarouselBuilder: DSViewBuilderProtocol {
    public static let modelKey = "smallNotificationCarouselOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSSmallNotificationCarouselModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let dataSource = DSSmallNotificationCarouselDataSource(sourceModel: data, eventHandler: eventHandler)
        
        let view = HorizontalCollectionView()
        view.configure(
            title: nil,
            datasource: dataSource,
            accessibilityDescridable: dataSource,
            cellSize: Constants.cellSize,
            cellTypes: [DSSmallNotificationItemCell.self, DSIconCardCell.self]
        )
        view.setupUI(pageControlDotColor: Constants.dotColor)
        
        let paddingBox = BoxView(subview: view).withConstraints(insets: Constants.paddingInsets)
        return paddingBox
    }
}

// MARK: - Data Source
class DSSmallNotificationCarouselDataSource: NSObject, UICollectionViewDataSource {
    private let sourceModel: DSSmallNotificationCarouselModel
    private let eventHandler: (ConstructorItemEvent) -> Void
    
    init(sourceModel: DSSmallNotificationCarouselModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.sourceModel = sourceModel
        self.eventHandler = eventHandler
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let selectedItem = sourceModel.items[indexPath.row]
        if let smallNotification = selectedItem.smallNotificationMlc {
            let cell: DSSmallNotificationItemCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(with: .init(model: smallNotification) { [weak self] in
                guard let action = smallNotification.action,
                      collectionView.isCellFullyVisible(at: indexPath)
                else { return }
                self?.eventHandler(.action(DSActionParameter(
                    type: action.type,
                    subtype: action.subtype,
                    resource: action.resource,
                    subresource: smallNotification.id
                )))
            })
            return cell
        }
        if let iconCard = selectedItem.iconCardMlc {
            let cell: DSIconCardCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(with: .init(model: iconCard) { [weak self] in
                if let action = iconCard.action {
                    self?.eventHandler(.action(action))
                }
            })
            return cell
        }

        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sourceModel.items.count
    }
}

// MARK: - AccessibilityDescribable
extension DSSmallNotificationCarouselDataSource: AccessibilityDescridable {
    var accessibilityDescriptions: [String]? {
        let descriptions = sourceModel.items.map { carouselItem in
            if let notification = carouselItem.smallNotificationMlc {
                return notification.accessibilityDescription ?? notification.label + notification.text
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
        let cellHeight = round(UIScreen.main.bounds.width * 0.28)
        return CGSize(width: cellWidth, height: cellHeight)
    }
    static let paddingInsets = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    static let dotColor = UIColor("#EEF7F1")
}
