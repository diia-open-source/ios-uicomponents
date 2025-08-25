
import UIKit
import DiiaCommonTypes

/// design_system_code: navigationPanelMlcV2
public struct DSNavigationPanelMlcV2Builder: DSViewBuilderProtocol {
    public let modelKey = "navigationPanelMlcV2"

    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSNavigationPanelV2 = object.parseValue(forKey: self.modelKey) else { return nil }

        let view = makeView(from: data,
                            eventHandler: eventHandler)
        let boxView = BoxView(subview: view).withConstraints(insets: padding.defaultPaddingV2(object: object, modelKey: modelKey))
        return boxView
    }

    public func makeView(from model: DSNavigationPanelV2,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> DSNavigationPanelV2View {
        let view = DSNavigationPanelV2View()
        view.configure(data: model, eventHandler: eventHandler)
        return view
    }
}

extension DSNavigationPanelMlcV2Builder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSNavigationPanelV2(
            componentId: "componentId",
            title: "Navigation Title",
            iconLeft: DSIconModel(code: "back", accessibilityDescription: "Кнопка: назад", action: .init(type: "back")),
            isClosed: false
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
