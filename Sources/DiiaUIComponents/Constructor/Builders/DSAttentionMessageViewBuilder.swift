
import UIKit
import DiiaCommonTypes

public struct DSAttentionMessageViewBuilder: DSViewBuilderProtocol {
    public static let modelKey = "attentionMessageMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let attentionMessage: ParameterizedAttentionMessage = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = ParameterizedAttentionView()
        view.configure(with: attentionMessage, urlOpener: UIComponentsConfiguration.shared.urlOpener)
        
        let insets = paddingType.defaultPadding()
        let boxView = BoxView(subview: view).withConstraints(insets: insets)
        return boxView
    }
}
