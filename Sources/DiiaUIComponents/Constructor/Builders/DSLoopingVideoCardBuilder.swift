
import UIKit
import DiiaCommonTypes

public struct DSLoopingVideoCardBuilder: DSViewBuilderProtocol {
    public static let modelKey = "loopingVideoPlayerCardMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSLoopingVideoCardMlc = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSLoopingVideoCardView()
        view.configure(with: data) {
            if let parameters = data.action {
                eventHandler(.action(parameters))
            }
        }
        
        let paddingBox = BoxView(subview: view).withConstraints(insets: paddingType.defaultPadding())
        return paddingBox
    }
}

private enum Constants {
    static let paddingInsets = UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 24)
}
