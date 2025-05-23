
import UIKit
import DiiaCommonTypes

public struct DSLargeTickerAtmViewBuilder: DSViewBuilderProtocol {
    public static let modelKey = "largeTickerAtm"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSTickerAtom = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSLargeTickerView()
        let viewModel = DSLargeTickerViewModel(usage: model.usage, type: .init(value: model.type), text: .init(value: model.value), action: model.action, componentId: model.componentId)
        view.configure(with: viewModel)
        eventHandler(.onComponentConfigured(with: .ticker(viewModel: viewModel)))
        let animationView = AnimationView(view)
        return BoxView(subview: animationView).withConstraints(insets: Constants.padding)
    }
}

extension DSLargeTickerAtmViewBuilder {
    private enum Constants {
        static let padding = UIEdgeInsets(top: 24, left: 0, bottom: 8, right: 0)
    }
}
