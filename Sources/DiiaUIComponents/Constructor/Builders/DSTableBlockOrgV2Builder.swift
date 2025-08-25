
import UIKit
import DiiaCommonTypes

public struct DSTableBlockOrgV2Builder: DSViewBuilderProtocol {
    public let modelKey = "tableBlockOrgV2"

    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSTextBlockV2Model = object.parseValue(forKey: self.modelKey) else { return nil }
        let view = DSTableBlockOrgV2View()

        if let viewFabric {
            view.setFabric(viewFabric)
        }

        view.configure(with: model, eventHandler: eventHandler)

        let insets = padding.defaultPaddingV2(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

/// design_system_code:  btnSlideMlc
public struct DSBtnSlideMlcBuilder: DSViewBuilderProtocol {
    public let modelKey = "btnSlideMlc"

    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSBtnSlideMlcModel = object.parseValue(forKey: self.modelKey) else { return nil }
        let view = DSBtnSlideMlcView()

        view.configure(with: model, eventHandler: eventHandler)

        let insets = padding.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}
