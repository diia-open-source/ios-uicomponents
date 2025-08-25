
import UIKit
import DiiaCommonTypes

/// design_system_code: backgroundWhiteOrg
public struct DSBackgroundWhiteViewBuilder: DSViewBuilderProtocol {
    public let modelKey = "backgroundWhiteOrg"
    
    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let data: DSBackgroundWhiteOrgModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
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
        
        let insets = padding.defaultPadding(object: object, modelKey: modelKey)
        let container = BoxView(subview: view).withConstraints(insets: insets)
        return container
    }
}

extension DSBackgroundWhiteViewBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSBackgroundWhiteOrgModel(
            componentId: "componentId",
            id: "mock_background_white_id",
            items: [
                DSRadioBtnGroupOrgV2Builder().makeMockModel(),
                DSListWidgetItemBuilder().makeMockModel()
            ]
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
