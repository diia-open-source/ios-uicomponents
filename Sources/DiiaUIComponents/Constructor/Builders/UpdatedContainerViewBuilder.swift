
import UIKit
import DiiaCommonTypes

/// design_system_code: updatedContainerOrg
public struct UpdatedContainerViewBuilder: DSViewBuilderProtocol {
    public let modelKey = "updatedContainerOrg"
    
    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let data: DSBackgroundWhiteOrgModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSContainerView()
        if let fabric = viewFabric {
            view.setFabric(fabric)
        }
        view.configure(for: DSContainerViewModel(
            subviews: data.items,
            componentId: data.componentId,
            eventHandler: eventHandler
        ))
        
        let insets = padding.insets(for: object, modelKey: modelKey, defaultInsets: .zero)
        let container = BoxView(subview: view).withConstraints(insets: insets)
        return container
    }
}

extension UpdatedContainerViewBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSBackgroundWhiteOrgModel(
            componentId: "componentId",
            id: "id",
            items: []
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
