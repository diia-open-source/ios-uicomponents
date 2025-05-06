
import UIKit
import DiiaCommonTypes

public struct DSCardMlcV2Builder: DSViewBuilderProtocol {
    public static let modelKey = "cardMlcV2"
    public func makeView(from object: AnyCodable, withPadding padding: DSViewPaddingType, viewFabric: DSViewFabric?, eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSCardMlcV2Model = object.parseValue(forKey: Self.modelKey) else { return nil }
        let view = DSCardMlcV2View()
        view.set(eventHandler: eventHandler)
        view.configure(with: model)
        let paddingBox = BoxView(subview: view).withConstraints(insets: Constants.paddingInsets)
        return paddingBox
    }
}

private enum Constants {
    static let paddingInsets = UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 24)
}
