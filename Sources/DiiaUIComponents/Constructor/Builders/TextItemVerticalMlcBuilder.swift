import UIKit
import DiiaCommonTypes

///DS_code: textItemVerticalMlc
public struct TextItemVerticalMlcBuilder: DSViewBuilderProtocol {
    public let modelKey = "textItemVerticalMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTextItemVerticalMlc = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = TextItemVerticalMlcView()
        view.configure(model: data)
        
        let insets = paddingType.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

extension TextItemVerticalMlcBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSTextItemVerticalMlc(
            componentId: "componentId",
            label: "label",
            value: "value",
            iconRight: DSIconModel(
                code: "code",
                accessibilityDescription: "accessibilityDescription",
                componentId: "componentId",
                action: .init(type: "iconAction"),
                isEnable: true
            )
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
