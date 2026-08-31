
///design system photoCardCarouselOrg
///
import UIKit
import DiiaCommonTypes

public struct PhotoCardCarouselBuilder: DSViewBuilderProtocol {
    public let modelKey = "photoCardCarouselOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: PhotoCardCarouseModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = PhotoCardCarouselView()
        view.configure(
            sourceModel: data,
            fabric: viewFabric ?? DSViewFabric.instance,
            cellSize: Constants.cellSize,
            cellTypes: [GenericCollectionViewCell.self],
            eventHandler: eventHandler
        )
        view.setupUI()
        let paddingBox = BoxView(subview: view).withConstraints(
            insets: paddingType.defaultCollectionPadding(object: object, modelKey: modelKey)
        )
        return paddingBox
    }
}

public struct PhotoCardCarouseModel: Codable {
    public let componentId: String
    public let minSelectedCount: Int?
    public let maxSelectedCount: Int?
    public let inputCode: String?
    public let controlType: String?
    public let items: [PhotoCardItemMlc]
    
    public init(componentId: String,
                minSelectedCount: Int?,
                maxSelectedCount: Int?,
                inputCode: String?,
                controlType: String?,
                items: [PhotoCardItemMlc]) {
        self.componentId = componentId
        self.minSelectedCount = minSelectedCount
        self.maxSelectedCount = maxSelectedCount
        self.inputCode = inputCode
        self.controlType = controlType
        self.items = items
    }
}

public struct PhotoCardItemMlc: Codable {
    public let photoCardMlc: PhotoCardMlc

    public init(photoCardMlc: PhotoCardMlc) {
        self.photoCardMlc = photoCardMlc
    }
}


private extension PhotoCardCarouselBuilder {
    enum Constants {
        static var cellSize: CGSize {
            let padding: CGFloat = 24
            let cardProportion: CGFloat = 11/9
            
            let cellWidth = UIScreen.main.bounds.width - padding * 2
            return CGSize(width: cellWidth, height: cellWidth*cardProportion)
        }
    }
}
