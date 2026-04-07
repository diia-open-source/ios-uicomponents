
import UIKit
import DiiaCommonTypes

struct TransparentInfoCardMlcBuilder: DSViewBuilderProtocol {
    public let modelKey = "transparentInfoCardMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: TransparentInfoCardMlcModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = TransparentInfoCardMlcView()
        view.configure(with: data, eventHandler: eventHandler)
        
        let insets = padding.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

extension TransparentInfoCardMlcBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = TransparentInfoCardMlcModel(
            componentId: "transparentInfoCardMlc",
            label: "Label",
            chipStatusAtm: .mock,
            rows: [.init(iconLeft: .mock, label: "rows label", value: "value")],
            bottomLeftLabel: .init(text: "bottomLeftLabel", additionalText: .init(text: "additionalText", isStrikethrough: true)),
            bottomRightLabel: .init(text: "text", iconRight: .mock),
            action: .mock,
            description: "description")
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
