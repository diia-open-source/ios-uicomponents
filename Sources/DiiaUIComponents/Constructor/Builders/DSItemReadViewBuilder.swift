
import UIKit
import DiiaCommonTypes

/// design_system_code: itemReadMlc
public struct DSItemReadViewBuilder: DSViewBuilderProtocol {
    public let modelKey = "itemReadMlc"
    
    public func makeView(
        from object: AnyCodable,
        withPadding paddingType: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let data: DSItemReadModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSItemReadView()
        view.configure(with: DSItemReadViewModel(
            componentId: data.componentId,
            label: data.label,
            value: data.value,
            icon: UIComponentsConfiguration.shared.imageProvider?.imageForCode(imageCode: data.iconRight?.code)
        ))
        let padding = paddingType.defaultPadding(object: object, modelKey: modelKey)
        
        let paddingBox = BoxView(subview: view).withConstraints(insets: padding)
        return paddingBox
    }
}

// MARK: - Mock
extension DSItemReadViewBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSItemReadModel(
            componentId: "componentId",
            label: "label",
            value: "value",
            iconRight: .mock
        )
        
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
