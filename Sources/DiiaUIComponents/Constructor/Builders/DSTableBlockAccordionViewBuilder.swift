
import UIKit
import DiiaCommonTypes

public struct DSTableBlockAccordionViewBuilder: DSViewBuilderProtocol {
    public let modelKey = "tableBlockAccordionOrg"
        
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSTableBlockAccordionModel = object.parseValue(forKey: self.modelKey) else { return nil }
        let view = DSTableBlockAccordionView()
        if let viewFabric {
            view.setFabric(viewFabric)
        }
        view.configure(with: model, eventHandler: eventHandler)
        let boxView = BoxView(subview: view).withConstraints(insets: padding.defaultPadding(object: object, modelKey: modelKey))
        return boxView
    }
    
    public func makeView(from model: DSTableBlockAccordionModel,
                  withPadding padding: DSViewPaddingType,
                         eventHandler: @escaping ((ConstructorItemEvent) -> Void)) -> UIView {
        let view = DSTableBlockAccordionView()
        view.configure(with: model, eventHandler: eventHandler)
        let boxView = BoxView(subview: view).withConstraints(insets: padding.defaultPadding())
        return boxView
    }
}

extension DSTableBlockAccordionViewBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSTableBlockAccordionModel(
            componentId: "componentId",
            heading: "heading",
            description: "description",
            isOpen: true,
            items: [
                .fromEncodable(encodable: DSTableItem(tableItemHorizontalMlc: .mock)),
            ]
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
