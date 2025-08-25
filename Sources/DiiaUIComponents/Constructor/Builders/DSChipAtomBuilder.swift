
import UIKit
import DiiaCommonTypes

public struct DSChipAtomBuilder: DSViewBuilderProtocol {
    public let modelKey = "chipStatusAtm"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSCardStatusChipModel = object.parseValue(forKey: self.modelKey) else { return nil }
        let view = DSChipStatusAtmView()
        view.accessibilityIdentifier = model.componentId
        view.configure(for: model)
        return view
    }
}

extension DSChipAtomBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSCardStatusChipModel(
            code: "status_chip",
            name: "Success",
            type: .success,
            componentId: "componentId"
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
