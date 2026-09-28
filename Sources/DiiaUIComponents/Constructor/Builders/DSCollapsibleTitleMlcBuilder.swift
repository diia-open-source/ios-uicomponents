
import UIKit
import DiiaCommonTypes

/// design_system_code: collapsibleTitleMlc
public struct DSCollapsibleTitleMlcBuilder: DSViewBuilderProtocol {
    public let modelKey = "collapsibleTitleMlc"

    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSCollapsibleTitleMlcModel = object.parseValue(forKey: self.modelKey) else { return nil }

        let view = DSCollapsibleTitleMlcView()
        view.setEventHandler(eventHandler)
        view.configure(model: data)

        let insets = padding.shortPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSCollapsibleTitleMlcBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSCollapsibleTitleMlcModel(
            componentId: "componentId",
            title: "This title could make a lot of lines, so it could be really, really, really, really, really long",
            expanded: DSCollapsibleTitleMlcExpanded(
                expandedText: "Показати більше",
                collapsedText: "Показати менше",
                isExpanded: false
            )
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
