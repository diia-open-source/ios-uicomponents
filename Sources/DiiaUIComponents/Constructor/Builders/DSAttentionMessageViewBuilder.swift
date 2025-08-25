
import UIKit
import DiiaCommonTypes

public struct DSAttentionMessageViewBuilder: DSViewBuilderProtocol {
    public let modelKey = "attentionMessageMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let attentionMessage: ParameterizedAttentionMessage = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = ParameterizedAttentionView()
        view.configure(with: attentionMessage, urlOpener: UIComponentsConfiguration.shared.urlOpener)
        
        let insets = paddingType.defaultPadding(object: object, modelKey: modelKey)
        let boxView = BoxView(subview: view).withConstraints(insets: insets)
        return boxView
    }
}

extension DSAttentionMessageViewBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = ParameterizedAttentionMessage(
            title: "title",
            text: "This is a mock attention message with {learnMore} and {contactSupport} parameters for testing purposes.",
            icon: "⚠️",
            parameters: [
                TextParameter(
                    type: .link,
                    data: TextParameterData(
                        name: "learnMore",
                        alt: "Learn More",
                        resource: "https://example.com/learn-more"
                    )
                )
            ]
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
