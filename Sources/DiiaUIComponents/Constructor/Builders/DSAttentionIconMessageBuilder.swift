
import UIKit
import DiiaCommonTypes

public struct DSAttentionIconMessageBuilder: DSViewBuilderProtocol {
    public let modelKey = "attentionIconMessageMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSAttentionIconMessageMlc = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSAttentionIconMessageView()
        view.configure(with: data, urlOpener: UIComponentsConfiguration.shared.urlOpener)
        view.setEventHandler(eventHandler)
        let paddingBox = BoxView(subview: view).withConstraints(insets: padding.shortPadding(object: object, modelKey: modelKey))
        return paddingBox
    }
}

extension DSAttentionIconMessageBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSAttentionIconMessageMlc(
            componentId: "componentId",
            smallIconAtm: DSIconModel(
                code: "bonds",
                accessibilityDescription: "Information icon",
                componentId: "mock_info_icon_component",
                action: DSActionParameter(
                    type: "info",
                    subtype: "attention",
                    resource: "mock_resource",
                    subresource: "mock_subresource"
                ),
                isEnable: true
            ),
            text: "This is a mock attention message with important information that users should be aware of.",
            parameters: [
                TextParameter(
                    type: .email,
                    data: TextParameterData(
                        name: "supportEmail",
                        alt: "support@example.com",
                        resource: "support@example.com"
                    )
                )
            ],
            backgroundMode: .info,
            expanded: DSAttentionIconMessageMlcExpanded(
                expandedText: "This is the expanded version of the attention message with additional detailed information that becomes visible when the user taps to expand the content.",
                collapsedText: "This is a mock attention message...",
                isExpanded: false
            )
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
