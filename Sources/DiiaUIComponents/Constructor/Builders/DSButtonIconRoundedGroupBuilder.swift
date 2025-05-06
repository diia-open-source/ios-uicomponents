
import UIKit
import DiiaCommonTypes

public struct DSButtonIconRoundedGroupBuilder: DSViewBuilderProtocol {
    public static let modelKey = "btnIconRoundedGroupOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSButtonIconRoundedGroupModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSButtonIconRoundedGroupView()
        view.configure(with: .init(
            items: data.items,
            touchCallback: { actionParameter in
                eventHandler(.action(actionParameter))
        }))
        
        let paddingBox = BoxView(subview: view).withConstraints(insets: padding.defaultCollectionPadding())
        return paddingBox
    }
}
