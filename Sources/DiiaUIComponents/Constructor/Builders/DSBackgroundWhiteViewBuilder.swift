
import UIKit
import DiiaCommonTypes

/// design_system_code: backgroundWhiteOrg
public struct DSBackgroundWhiteViewBuilder: DSViewBuilderProtocol {
    public static let modelKey = "backgroundWhiteOrg"
    
    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let data: DSBackgroundWhiteOrgModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSBackgroundWhiteView()
        if let fabric = viewFabric {
            view.setFabric(fabric)
        }
        view.configure(for: DSBackgroundWhiteViewModel(
            title: nil,
            subviews: data.items,
            componentId: data.componentId,
            eventHandler: eventHandler
        ))
        
        let insets = padding.defaultPadding()
        let container = BoxView(subview: view).withConstraints(insets: insets)
        return container
    }
}
