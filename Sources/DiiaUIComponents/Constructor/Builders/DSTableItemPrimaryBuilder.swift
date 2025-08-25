import UIKit
import DiiaCommonTypes

public struct DSTableItemPrimaryBuilder: DSViewBuilderProtocol {
    public let modelKey = "tableItemPrimary"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSTableItemPrimaryMlc = object.parseValue(forKey: self.modelKey) else { return nil }
        let view = DSTableItemPrimaryView()
        view.configure(model: model)
        let box = BoxView(subview: view).withConstraints(insets: paddingType.insets(for: object, modelKey: modelKey, defaultInsets: .zero))
        return box
    }
}

extension DSTableItemPrimaryBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSTableItemPrimaryMlc(label: "label(optional)", value: "value", icon: .mock)
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
