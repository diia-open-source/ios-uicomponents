
import UIKit
import DiiaCommonTypes

public struct DSChipAtomBuilder: DSViewBuilderProtocol {
    public static let modelKey = "chipStatusAtm"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSCardStatusChipModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        let view = DSChipStatusAtmView()
        view.accessibilityIdentifier = model.componentId
        view.configure(for: model)
        return view
    }
}
