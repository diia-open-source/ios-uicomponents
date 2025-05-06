
import UIKit
import DiiaCommonTypes

public struct DSPhotoGroupOrgBuilder: DSViewBuilderProtocol {
    public static let modelKey = "photoGroupOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSPhotoGroupOrg = object.parseValue(forKey: Self.modelKey) else { return nil }
        let view = DSPhotoGroupOrgView()
        view.configure(with: data)
        let insets = padding.defaultPadding()
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}
