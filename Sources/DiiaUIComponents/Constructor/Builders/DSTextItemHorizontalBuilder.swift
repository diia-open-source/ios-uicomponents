
import UIKit
import DiiaCommonTypes

/// design_system_code: textLabelMlc
public struct DSTextItemHorizontalBuilder: DSViewBuilderProtocol {
    public let modelKey = "textItemHorizontalMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTextItemHorizontalModel = object.parseValue(forKey: self.modelKey) else { return nil }

        let textView = DSTextItemHorizontalView()
        textView.configure(with: data)
        let padding = paddingType.defaultPaddingV2(object: object, modelKey: modelKey)
        
        let paddingBox = BoxView(subview: textView).withConstraints(insets: padding)
        textView.accessibilityIdentifier = data.componentId
        return paddingBox
    }
}

extension DSTextItemHorizontalBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSTextItemHorizontalModel(
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
