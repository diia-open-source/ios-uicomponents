import UIKit
import DiiaCommonTypes

public struct DSTableItemPrimaryBuilder: DSViewBuilderProtocol {
    public static let modelKey = "tableItemPrimary"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSTableItemPrimaryMlc = object.parseValue(forKey: Self.modelKey) else { return nil }
        let view = DSTableItemPrimaryView()
        view.configure(model: model)
        return view
    }
}
