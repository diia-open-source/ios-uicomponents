
import UIKit
import DiiaCommonTypes

public struct DSRecursiveContainerOrgBuilder: DSViewBuilderProtocol {
    public static let modelKey = "recursiveContainerOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSRecursiveContainerOrgModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        let view = DSRecursiveContainerOrgView()
        if let viewFabric {
            view.setFabric(viewFabric)
        }
        view.setEventHandler(eventHandler)
        view.accessibilityIdentifier = model.componentId
        view.configure(for: model)
        let insets = paddingType.defaultPadding()
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}
