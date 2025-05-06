
import UIKit
import DiiaCommonTypes

public struct DSTableBlockAccordionViewBuilder: DSViewBuilderProtocol {
    public static let modelKey = "tableBlockAccordionOrg"
        
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSTableBlockAccordionModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        let view = DSTableBlockAccordionView()
        if let viewFabric {
            view.setFabric(viewFabric)
        }
        view.configure(with: model, eventHandler: eventHandler)
        let boxView = BoxView(subview: view).withConstraints(insets: padding.defaultPadding())
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
