
import UIKit
import DiiaCommonTypes

public struct DSCardListViewBuilder: DSViewBuilderProtocol {
    public static let modelKey = "cardMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSCardModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        let view = DSCommonCardView()
        let viewModel = DSCommonCardViewModel(model: model, actionHandler: { action in
            eventHandler(.action(action))
        })
        view.configure(with: viewModel)
        let paddingBox = BoxView(subview: view).withConstraints(insets: padding.defaultPadding())
        return paddingBox
    }
}
