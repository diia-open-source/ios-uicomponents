
import UIKit
import DiiaCommonTypes

/// ds_code: btnIconPlainStrokeMlc
public struct DSBtnIconPlainStrokeMlcBuilder: DSViewBuilderProtocol {
    public let modelKey = "btnIconPlainStrokeMlc"

    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSBtnIconPlainStrokeMlcModel = object.parseValue(forKey: self.modelKey) else { return nil }
        let view = DSBtnIconPlainStrokeMlcView()
        view.configure(with: data, eventHandler: eventHandler)
        let paddingBox = BoxView(subview: view).withConstraints(insets: padding.defaultPaddingV2(object: object, modelKey: modelKey))
        return paddingBox
    }
}

extension DSBtnIconPlainStrokeMlcBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSBtnIconPlainStrokeMlcModel(
            componentId: "componentId",
            label: "label",
            state: nil,
            iconLeft: .mock,
            action: .mock
        )

        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
