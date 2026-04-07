
import UIKit
import DiiaCommonTypes

///ds_code: transparentBtnMlc
public struct DSTransparentBtnMlcBuilder: DSViewBuilderProtocol {
    public let modelKey = "transparentBtnMlc"

    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTransparentBtnMlcModel = object.parseValue(forKey: self.modelKey) else { return nil }

        let view = DSTransparentBtnMlcView()
        view.configure(with: data, eventHandler: eventHandler)

        let insets = padding.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSTransparentBtnMlcBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSTransparentBtnMlcModel(
            componentId: "transparentBtnMlc",
            label: "Label",
            iconRight: .mock,
            action: .mock,
            state: nil
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
