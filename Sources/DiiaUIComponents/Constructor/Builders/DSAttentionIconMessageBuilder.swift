
import UIKit
import DiiaCommonTypes

public struct DSAttentionIconMessageBuilder: DSViewBuilderProtocol {
    
    public static let modelKey = "attentionIconMessageMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSAttentionIconMessageMlc = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSAttentionIconMessageView()
        view.configure(with: data)
        
        let paddingBox = BoxView(subview: view).withConstraints(insets: padding.shortPadding())
        return paddingBox
    }
}
