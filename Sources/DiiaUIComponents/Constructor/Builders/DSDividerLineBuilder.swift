
import UIKit
import DiiaCommonTypes

/// design_system_code: dividerLineMlc
public struct DSDividerLineBuilder: DSViewBuilderProtocol {
    public static let modelKey = "dividerLineMlc"
    
    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let data: DSDividerLineModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSDividerLineView()
        view.configure(with: data)
        
        let insets = padding.defaultPadding()
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}
