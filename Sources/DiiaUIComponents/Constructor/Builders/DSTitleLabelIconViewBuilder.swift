
import UIKit
import DiiaCommonTypes

/// design_system_code: titleLabelIconMlc
public struct DSTitleLabelIconViewBuilder: DSViewBuilderProtocol {
    public let modelKey = "titleLabelIconMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTitleLabelIconMlc = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSTitleLabelIconView()
        view.configure(data: data)
        
        let insets = padding.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSTitleLabelIconViewBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSTitleLabelIconMlc(
            componentId: "componentId",
            label: "label label",
            logoAtm: DSLogoAtm(
                componentId: "componentId",
                logo: "home",
                accessibilityDescription: "accessibilityDescription",
                action: .mock
            )
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
