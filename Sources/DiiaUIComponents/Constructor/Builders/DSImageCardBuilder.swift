
import UIKit
import DiiaCommonTypes

public struct DSImageCardBuilder: DSViewBuilderProtocol {
    public static let modelKey = "imageCardMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSImageCardModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSImageCardView()
        view.configure(with: data) {
            eventHandler(.action(data.action))
        }
        
        let paddingBox = BoxView(subview: view).withConstraints(insets: paddingType.defaultPadding())
        return paddingBox
    }
}

private enum Constants {
    static let paddingInsets = UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 24)
}
