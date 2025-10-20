
import UIKit
import DiiaCommonTypes

public struct DSTickerAtmBuilder: DSViewBuilderProtocol {
    public let modelKey = "tickerAtm"
    private let padding: UIEdgeInsets
    
    public init(padding: UIEdgeInsets = .zero) {
        self.padding = padding
    }
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSTickerAtom = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSTickerView()
        view.configure(with: model, eventHandler: eventHandler)
        let box = BoxView(subview: view).withConstraints(insets: paddingType.insets(for: object, modelKey: modelKey, defaultInsets: padding))
        return box
    }
}

extension DSTickerAtmBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSTickerAtom(
            usage: .bodyOrg,
            type: .informative,
            value: "value",
            action: .mock,
            componentId: "componentId"
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
