
import UIKit
import DiiaCommonTypes

public struct DSAccordionOrgBuilder: DSViewBuilderProtocol {
    public let modelKey = "accordionOrg"

    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
            guard let model: DSAccordionOrgModel = object.parseValue(forKey: self.modelKey) else { return nil }

            let view = DSAccordionOrgView()

            if let viewFabric {
                view.setFabric(viewFabric)
            }

            view.configure(with: model, eventHandler: eventHandler)

            let insets = padding.defaultPadding(object: object, modelKey: modelKey)
            let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
            return paddingBox
    }
}

extension DSAccordionOrgBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSAccordionOrgModel(
            componentId: "componentId",
            heading: "heading",
            description: "description",
            states: DSAccordionOrgState(
                isExpanded: true,
                expandedIcon: DSIconModel(
                    code: "code",
                    accessibilityDescription: "accessibilityDescription",
                    componentId: "componentId",
                    action: .init(type: "iconAction"),
                    isEnable: true
                ),
                collapsedIcon: DSIconModel(
                    code: "code",
                    accessibilityDescription: "accessibilityDescription",
                    componentId: "componentId",
                    action: .init(type: "iconAction"),
                    isEnable: true
                )
            ),
            expandedContent: DSAccordionOrgExpandedContentModel(items: []))
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
