
import UIKit
import DiiaCommonTypes

public struct DSTableAccordionOrgViewBuilder: DSViewBuilderProtocol {
    public let modelKey = "tableAccordionOrg"

    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSTableAccordionOrgModel = object.parseValue(forKey: self.modelKey) else { return nil }
        let view = DSTableAccordionOrgView()
        if let viewFabric {
            view.setFabric(viewFabric)
        }
        view.configure(with: model, urlOpener: UIComponentsConfiguration.shared.urlOpener, eventHandler: eventHandler)

        let paddings = padding.defaultPaddingV2(object: object, modelKey: modelKey)
        let boxView = BoxView(subview: view).withConstraints(insets: paddings)
        return boxView
    }
}

extension DSTableAccordionOrgViewBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSTableAccordionOrgModel(
            componentId: "componentId",
            tableMainHeadingMlc: .mock,
            items: [
                DSAccordionOrgBuilder().makeMockModel()
            ],
            attentionIconMessageMlc: .mock
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
