
import UIKit
import DiiaCommonTypes

public struct DSImageViewBuilder: DSViewBuilderProtocol {
    public let modelKey = "articlePicAtm"

    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSImageData = object.parseValue(forKey: self.modelKey) else { return nil }
        let view = DSImageContainerView()
        view.configure(data: data)
        view.layer.cornerRadius = Constants.cornerRadius
        view.clipsToBounds = true

        let insets = paddingType.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSImageViewBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSImageData(
            image: "https://mockurl.com/image.png",
            accessibilityDescription: "Mock image description"
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}

struct DSAvatarViewBuilder: DSViewBuilderProtocol {
    public let modelKey = "photoItem"

    public func makeView(from object: AnyCodable,
                  withPadding paddingType: DSViewPaddingType,
                  viewFabric: DSViewFabric?,
                  eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSDocumentContentData = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = makeView(data: data, eventHandler: eventHandler)
        let insets = paddingType.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }

    public func makeView(data: DSDocumentContentData, eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView {
        let view = DSDocPhotoView()
        view.configure(content: data.rawValue)
        return view
    }
}

private enum Constants {
    static let cornerRadius: CGFloat = 16
}
