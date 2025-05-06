
import UIKit
import DiiaCommonTypes

/// design_system_code: titleLabelIconMlc
public struct DSTitleLabelIconViewBuilder: DSViewBuilderProtocol {
    public static let modelKey = "titleLabelIconMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTitleLabelIconMlc = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSTitleLabelIconView()
        view.configure(data: data)
        
        let insets = padding.defaultPadding()
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}
