

import UIKit
import DiiaCommonTypes

///design_system_code: cardImageMlc
public struct CardImageMlcBuilder: DSViewBuilderProtocol {
    public let modelKey = "cardImageMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let cardProgressMlc: CardImageMlc = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = CardImageMlcView()
        view.configure(with: cardProgressMlc)
        let insets = padding.defaultPaddingV2(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        
        return paddingBox
    }
}

extension CardImageMlcBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = CardImageMlc(
            componentId: "cardImageMlc",
            label: "label",
            description: "description",
            accessibilityDescription: "accessibilityDescription",
            attentionIconMessageMlc: .mock,
            image: "https://example.com/image.png",
            gif: nil,
            action: .mock)
        
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}

public struct CardImageMlc: Codable {
    public let componentId: String?
    public let label: String?
    public let description: String?
    public let accessibilityDescription: String?
    public let attentionIconMessageMlc: DSAttentionIconMessageMlc?
    public let image: String?
    public let gif: String?
    public let gifAccessibilityDescription: String?
    public let action: DSActionParameter?
    
    public init(
        componentId: String? = nil,
        label: String? = nil,
        description: String? = nil,
        accessibilityDescription: String? = nil,
        attentionIconMessageMlc: DSAttentionIconMessageMlc? = nil,
        image: String? = nil,
        gif: String? = nil,
        gifAccessibilityDescription: String? = nil,
        action: DSActionParameter? = nil) {
            self.componentId = componentId
            self.label = label
            self.description = description
            self.accessibilityDescription = accessibilityDescription
            self.attentionIconMessageMlc = attentionIconMessageMlc
            self.image = image
            self.gif = gif
            self.gifAccessibilityDescription = gifAccessibilityDescription
            self.action = action
        }
}
