
import UIKit
import DiiaCommonTypes

public struct DSPhotoGroupOrgBuilder: DSViewBuilderProtocol {
    public let modelKey = "photoGroupOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSPhotoGroupOrg = object.parseValue(forKey: self.modelKey) else { return nil }
        let view = DSPhotoGroupOrgView()
        view.configure(with: data)
        let insets = padding.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

// MARK: - Mock
extension DSPhotoGroupOrgBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSPhotoGroupOrg(
            componentId: "componentId",
            pictures: [
                DSImageData(image: "base64Format", accessibilityDescription: "accessibilityDescription"),
                DSImageData(image: "https://mockUrl/image.jpg", accessibilityDescription: "accessibilityDescription")
            ]
        )
        
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
