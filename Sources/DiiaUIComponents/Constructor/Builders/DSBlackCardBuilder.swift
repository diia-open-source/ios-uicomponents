
import UIKit
import DiiaCommonTypes

public struct DSBlackCardBuilder: DSViewBuilderProtocol {
    public static let modelKey = "blackCardMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSBlackCardModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSBlackCardView()
        view.configure(with: data) {
            eventHandler(.action(data.action))
        }
        
        let paddingBox = BoxView(subview: view).withConstraints(insets: Constants.paddingInsets)
        return paddingBox
    }
}

private enum Constants {
    static let paddingInsets = UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 24)
}
