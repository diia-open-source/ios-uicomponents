
/// alertCardMlc

import UIKit
import DiiaCommonTypes

public struct DSAlertCardBuilder: DSViewBuilderProtocol {
    public static let modelKey = "alertCardMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSAlertCardMlc = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let alertButtonView = DSAlertCardMlcView()
        alertButtonView.configure(model: data) { action in
            eventHandler(.action(action))
        }
        
        let insets = padding.defaultPadding()
        let paddingBox = BoxView(subview: alertButtonView).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSAlertCardBuilder {
    enum Constants {
        static let stackInsets = UIEdgeInsets.init(top: 24, left: 24, bottom: 0, right: 24)
    }
}
