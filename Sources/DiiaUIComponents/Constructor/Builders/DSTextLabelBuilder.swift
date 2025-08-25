
import UIKit
import DiiaCommonTypes

/// design_system_code: textLabelMlc
public struct DSTextLabelBuilder: DSViewBuilderProtocol {
    public let modelKey = "textLabelMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTextContainerData = object.parseValue(forKey: self.modelKey) else { return nil }

        let textView = DSTextContainerView()
        textView.configure(data: data)
        let padding = paddingType.defaultPadding(object: object, modelKey: modelKey)
        
        let paddingBox = BoxView(subview: textView).withConstraints(insets: padding)
        textView.accessibilityIdentifier = data.componentId
        return paddingBox
    }
}

extension DSTextLabelBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSTextContainerData(
            componentId: "componentId",
            text: "text",
            label: "label",
            parameters: [
                TextParameter(
                    type: .link,
                    data: TextParameterData(name: "name", alt: "alt", resource: "resource")
                )
            ]
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
