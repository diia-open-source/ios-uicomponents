
import UIKit
import DiiaCommonTypes

public struct DSCardMlcV2Builder: DSViewBuilderProtocol {
    public let modelKey = "cardMlcV2"
    public func makeView(from object: AnyCodable, withPadding padding: DSViewPaddingType, viewFabric: DSViewFabric?, eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSCardMlcV2Model = object.parseValue(forKey: self.modelKey) else { return nil }

        let viewModel = DSCardMlcV2ViewModel(model: model)

        viewModel.onTap = { [weak viewModel] action in
            guard let action, let viewModel else { return }
            eventHandler(.cardMlcAction(parameters: action, viewModel: viewModel))
        }

        let view = DSCardMlcV2View()
        view.set(eventHandler: eventHandler)
        view.configure(with: viewModel)

        let insets = padding.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSCardMlcV2Builder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSCardMlcV2Model(
            componentId: "componentId",
            chipStatusAtm: DSCardStatusChipModel(
                code: "status_active",
                name: "Active",
                type: .success,
                componentId: "componentId"
            ),
            label: "Mock Card V2 Label",
            rightLabel: "Right Label",
            descriptions: [
                "First description line",
                "Second description line"
            ],
            rows: [
                "Row 1 content",
                "Row 2 content",
                "Row 3 content"
            ],
            chips: [
                DSCardStatusChipMlc(
                    chipStatusAtm: DSCardStatusChipModel(
                        code: "chip_1",
                        name: "Chip 1",
                        type: .pending,
                        componentId: "componentId"
                    )
                ),
                DSCardStatusChipMlc(
                    chipStatusAtm: DSCardStatusChipModel(
                        code: "chip_2",
                        name: "Chip 2",
                        type: .blue,
                        componentId: "componentId"
                    )
                )
            ],
            iconUrlAtm: DSIconUrlAtmModel(
                componentId: "componentId",
                url: "https://example.com/icon.png",
                accessibilityDescription: "Mock icon from URL",
                action: DSActionParameter(
                    type: "icon",
                    subtype: "url",
                    resource: "mock_resource",
                    subresource: "mock_subresource"
                )
            ),
            smallIconAtm: DSIconModel(
                code: "home",
                accessibilityDescription: "Small home icon",
                componentId: "componentId",
                action: DSActionParameter(
                    type: "icon",
                    subtype: "small",
                    resource: "mock_resource",
                    subresource: "mock_subresource"
                ),
                isEnable: true
            ),
            smallIconAtmWithStates: DSSmallIconAtmWithStatesModel(
                currentState: "active",
                states: [
                    DSSmallIconAtmState(
                        name: "active",
                        icon: DSIconModel(
                            code: "info",
                            accessibilityDescription: "Active state icon",
                            componentId: "componentId",
                            action: DSActionParameter(
                                type: "state",
                                subtype: "active",
                                resource: "mock_resource",
                                subresource: "mock_subresource"
                            ),
                            isEnable: true
                        )
                    ),
                    DSSmallIconAtmState(
                        name: "inactive",
                        icon: DSIconModel(
                            code: "homedoc",
                            accessibilityDescription: "Inactive state icon",
                            componentId: "componentId",
                            action: DSActionParameter(
                                type: "state",
                                subtype: "inactive",
                                resource: "mock_resource",
                                subresource: "mock_subresource"
                            ),
                            isEnable: false
                        )
                    )
                ]
            ),
            attentionIconMessageMlc: DSAttentionIconMessageMlc(
                componentId: "componentId",
                smallIconAtm: DSIconModel(
                    code: "info",
                    accessibilityDescription: "Attention icon",
                    componentId: "componentId",
                    action: DSActionParameter(
                        type: "attention",
                        subtype: "message",
                        resource: "mock_resource",
                        subresource: "mock_subresource"
                    ),
                    isEnable: true
                ),
                text: "This is an attention message within the card",
                parameters: [
                    TextParameter(
                        type: .link,
                        data: TextParameterData(
                            name: "learnMore",
                            alt: "Learn More",
                            resource: "https://example.com"
                        )
                    )
                ],
                backgroundMode: .info,
                expanded: DSAttentionIconMessageMlcExpanded(
                    expandedText: "Expanded attention message with more details",
                    collapsedText: "This is an attention message...",
                    isExpanded: false
                ),
                btnStrokeAdditionalAtm: .mock
            ),
            action: DSActionParameter(
                type: "card",
                subtype: "v2",
                resource: "mock_resource",
                subresource: "mock_subresource"
            )
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
