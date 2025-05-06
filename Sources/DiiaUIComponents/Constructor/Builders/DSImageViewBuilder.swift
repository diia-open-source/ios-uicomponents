
import UIKit
import DiiaCommonTypes

public struct DSImageViewBuilder: DSViewBuilderProtocol {
    public static let modelKey = "articlePicAtm"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSImageData = object.parseValue(forKey: Self.modelKey) else { return nil }
        let view = DSImageContainerView()
        view.configure(data: data)
        view.layer.cornerRadius = Constants.cornerRadius
        view.clipsToBounds = true
        
        let insets = paddingType.defaultPadding()
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

struct DSAvatarViewBuilder: DSViewBuilderProtocol {
    public static let modelKey = "photoItem"
    
    func makeView(from object: AnyCodable,
                  withPadding paddingType: DSViewPaddingType,
                  viewFabric: DSViewFabric?,
                  eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSDocumentContentData = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = makeView(data: data, eventHandler: eventHandler)
        let insets = paddingType.defaultPadding()
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
    
    func makeView(data: DSDocumentContentData, eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView {
        let view = DSDocPhotoView()
        view.configure(content: data.rawValue)
        return view
    }
}

private enum Constants {
    static let cornerRadius: CGFloat = 16
}
