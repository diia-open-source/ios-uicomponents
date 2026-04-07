
import UIKit
import DiiaCommonTypes

/// design_system_code: backgroundWhiteOrgV2
public struct DSBackgroundWhiteViewV2Builder: DSViewBuilderProtocol {
    public let modelKey = "backgroundWhiteOrgV2"
    
    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let data: DSBackgroundWhiteOrgModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSBackgroundWhiteViewV2()
        if let fabric = viewFabric {
            view.setFabric(fabric)
        }
        view.configure(for: DSBackgroundWhiteViewModel(
            title: nil,
            subviews: data.items,
            componentId: data.componentId,
            eventHandler: eventHandler
        ))
        
        let insets = padding.defaultPaddingV2(object: object, modelKey: modelKey)
        let container = BoxView(subview: view).withConstraints(insets: insets)
        return container
    }
}

extension DSBackgroundWhiteViewV2Builder: DSViewMockableBuilderProtocol {
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
