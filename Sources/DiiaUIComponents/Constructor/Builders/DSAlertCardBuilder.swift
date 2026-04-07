
/// alertCardMlc

import UIKit
import DiiaCommonTypes

public struct DSAlertCardBuilder: DSViewBuilderProtocol {
    public let modelKey = "alertCardMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSAlertCardMlc = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let alertButtonView = DSAlertCardMlcView()
        alertButtonView.configure(model: data) { action in
            eventHandler(.action(action))
        }
        
        let insets = padding.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: alertButtonView).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSAlertCardBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSAlertCardMlc(
            icon: "icon",
            label: "label",
            text: "text",
            btnAlertAdditionalAtm: DSButtonModel(
                label: "label",
                state: DSButtonState.enabled,
                action: DSActionParameter(
                    type: "type",
                    subtype: "subtype",
                    resource: "resource",
                    subresource: "subresource"),
                componentId: "componentId"
            )
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
