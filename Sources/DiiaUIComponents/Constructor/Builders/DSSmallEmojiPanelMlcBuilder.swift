import UIKit
import DiiaCommonTypes

/// design_system_code: smallEmojiPanelMlc
public struct DSSmallEmojiPanelMlcBuilder: DSViewBuilderProtocol {
    public static let modelKey = "smallEmojiPanelMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSSmallEmojiPanelMlcl = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = SmallButtonPanelMlcView()
        view.configure(for: data, color: .white)
        return BoxView(subview: view).withConstraints(insets: paddingType.defaultPadding())
    }
}
