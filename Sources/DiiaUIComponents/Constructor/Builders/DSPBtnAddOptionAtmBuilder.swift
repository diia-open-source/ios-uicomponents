
import UIKit
import DiiaCommonTypes

/// design_system_code: btnAddOptionAtm
public struct DSPBtnAddOptionAtmBuilder: DSViewBuilderProtocol {
    public let modelKey = "btnAddOptionAtm"

    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSBtnAddOptionAtm = object.parseValue(forKey: self.modelKey) else { return nil }

        let view = DSBtnAddOptionAtmView()
        view.configure(with: model, eventHandler: eventHandler)

        let padding = paddingType.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: padding)
        return paddingBox
    }
}

extension DSPBtnAddOptionAtmBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSBtnAddOptionAtm(
                componentId: "addOption",
                label: "Add Document",
                description: "Upload Document",
                iconLeft: .mock,
                state: .enabled,
                action: .mock)
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
