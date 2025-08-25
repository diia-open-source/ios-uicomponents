
import UIKit
import DiiaCommonTypes

public struct DSCardListViewBuilder: DSViewBuilderProtocol {
    public let modelKey = "cardMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSCardModel = object.parseValue(forKey: self.modelKey) else { return nil }
        let view = DSCommonCardView()
        let viewModel = DSCommonCardViewModel(model: model, actionHandler: { action in
            eventHandler(.action(action))
        })
        view.configure(with: viewModel)
        let paddingBox = BoxView(subview: view).withConstraints(insets: padding.defaultPadding(object: object, modelKey: modelKey))
        return paddingBox
    }
}

extension DSCardListViewBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSCardModel(
            componentId: "componentId",
            id: "mock_card_1",
            title: "Mock Card Title",
            chipStatusAtm: DSCardStatusChipModel(
                code: "status_active",
                name: "Active",
                type: .success,
                componentId: "componentId"
            ),
            label: "Mock Label",
            subtitle: DSCardSubtitleModel(
                icon: "home",
                value: "Mock Subtitle"
            ),
            subtitles: [
                DSCardSubtitleModel(
                    icon: "info",
                    value: "First Subtitle"
                ),
                DSCardSubtitleModel(
                    icon: "homedoc",
                    value: "Second Subtitle"
                )
            ],
            description: "This is a mock card description with detailed information.",
            botLabel: "Bottom Label",
            tickerAtm: DSTickerAtom(
                usage: .document,
                type: .positive,
                value: "Mock Ticker",
                action: DSActionParameter(
                    type: "ticker",
                    subtype: "card",
                    resource: "mock_resource",
                    subresource: "mock_subresource"
                ),
                componentId: "componentId"
            ),
            btnStrokeAdditionalAtm: DSButtonModel(
                label: "Stroke Button",
                state: .enabled,
                action: DSActionParameter(
                    type: "button",
                    subtype: "stroke",
                    resource: "mock_resource",
                    subresource: "mock_subresource"
                ),
                componentId: "componentId"
            ),
            btnPrimaryAdditionalAtm: DSButtonModel(
                label: "Primary Button",
                state: .enabled,
                action: DSActionParameter(
                    type: "button",
                    subtype: "primary",
                    resource: "mock_resource",
                    subresource: "mock_subresource"
                ),
                componentId: "componentId"
            )
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
