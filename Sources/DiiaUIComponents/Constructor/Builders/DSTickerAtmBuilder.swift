
import UIKit
import DiiaCommonTypes

public struct DSTickerAtmBuilder: DSViewBuilderProtocol {
    public static let modelKey = "tickerAtm"
    private let padding: UIEdgeInsets
    
    public init(padding: UIEdgeInsets = .zero) {
        self.padding = padding
    }
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSTickerAtom = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSTickerView()
        view.configure(with: model)
        return BoxView(subview: AnimationView(view)).withConstraints(insets: padding)
    }
}
