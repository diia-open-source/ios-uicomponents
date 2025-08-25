
import UIKit
import DiiaCommonTypes

public struct DSAlertCardV2Builder: DSViewBuilderProtocol {
    public let modelKey = "alertCardMlcV2"

    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSAlertCardMlcV2Model = object.parseValue(forKey: self.modelKey) else { return nil }

        let view = DSAlertCardMlcV2View()
        view.configure(model: model, eventHandler: eventHandler)

        let insets = padding.defaultPaddingV2(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSAlertCardV2Builder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSAlertCardMlcV2Model(
            icon: DSIconModel(
                code: "code",
                accessibilityDescription: "accessibilityDescription",
                componentId: "componentId",
                action: .init(type: "iconAction"),
                isEnable: true
            ),
            title: "label",
            subtitle: "text",
            buttonModel: DSButtonModel(
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
