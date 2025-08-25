
import UIKit
import DiiaCommonTypes

/// design_system_code: dividerLineMlc
public struct DSDividerLineBuilder: DSViewBuilderProtocol {
    public let modelKey = "dividerLineMlc"
    
    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let data: DSDividerLineModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSDividerLineView()
        view.configure(with: data)
        
        let insets = padding.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

// MARK: - Mock
extension DSDividerLineBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSDividerLineModel(
            componentId: "componentId",
            type: "type"
        )
        
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
