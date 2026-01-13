
import UIKit
import DiiaCommonTypes

/// design_system_code: linkSharingMlc
public struct DSLinkSharingMlcBuilder: DSViewBuilderProtocol {
    public let modelKey = "linkSharingMlc"

    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSLinkSharingMlcModel = object.parseValue(forKey: self.modelKey) else { return nil }

        let view = DSLinkSharingMlcView()
        view.configure(with: model, eventHandler: eventHandler)
        let box = BoxView(subview: view).withConstraints(insets: paddingType.defaultPaddingV2(object: object, modelKey: self.modelKey))
        return box
    }
}

// MARK: - Mock
extension DSLinkSharingMlcBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSLinkSharingMlcModel(
            componentId: "componentId",
            label: "label"
        )
        
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
