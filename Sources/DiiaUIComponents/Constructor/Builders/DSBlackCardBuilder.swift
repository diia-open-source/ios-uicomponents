
import UIKit
import DiiaCommonTypes

public struct DSBlackCardBuilder: DSViewBuilderProtocol {
    public let modelKey = "blackCardMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSBlackCardModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSBlackCardView()
        view.configure(with: data) {
            eventHandler(.action(data.action))
        }
        
        let paddingBox = BoxView(subview: view).withConstraints(insets: Constants.paddingInsets)
        return paddingBox
    }
}

extension DSBlackCardBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSBlackCardModel(
            smallIconAtm: DSIconModel(
                code: "ellipseWhiteArrowRight",
                accessibilityDescription: "ellipseWhiteArrowRight icon",
                componentId: "componentId",
                action: DSActionParameter(
                    type: "info",
                    subtype: "card",
                    resource: "mock_resource",
                    subresource: "mock_subresource"
                ),
                isEnable: true
            ),
            iconAtm: DSIconModel(
                code: "star",
                accessibilityDescription: "Star icon",
                componentId: "componentId",
                action: DSActionParameter(
                    type: "star",
                    subtype: "card",
                    resource: "mock_resource",
                    subresource: "mock_subresource"
                ),
                isEnable: true
            ),
            doubleIconAtm: DSIconModel(
                code: "double",
                accessibilityDescription: "Double icon",
                componentId: "componentId",
                action: DSActionParameter(
                    type: "double",
                    subtype: "card",
                    resource: "mock_resource",
                    subresource: "mock_subresource"
                ),
                isEnable: true
            ),
            title: "Mock Black Card Title",
            label: "Mock black card label with details",
            action: DSActionParameter(
                type: "card",
                subtype: "black",
                resource: "mock_resource",
                subresource: "mock_subresource"
            )
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}

private enum Constants {
    static let paddingInsets = UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 24)
}
