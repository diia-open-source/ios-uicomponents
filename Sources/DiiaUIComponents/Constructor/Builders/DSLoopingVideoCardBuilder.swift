
import UIKit
import DiiaCommonTypes

public struct DSLoopingVideoCardBuilder: DSViewBuilderProtocol {
    public let modelKey = "loopingVideoPlayerCardMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSLoopingVideoCardMlc = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSLoopingVideoCardView()
        view.configure(with: data) {
            if let parameters = data.action {
                eventHandler(.action(parameters))
            }
        }
        
        let paddingBox = BoxView(subview: view).withConstraints(insets: paddingType.defaultPadding(object: object, modelKey: modelKey))
        return paddingBox
    }
}

private enum Constants {
    static let paddingInsets = UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 24)
}

extension DSLoopingVideoCardBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSLoopingVideoCardMlc(
            componentId: "componentId",
            video: "video",
            label: "label",
            iconRight: "iconRight",
            action: .mock
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
