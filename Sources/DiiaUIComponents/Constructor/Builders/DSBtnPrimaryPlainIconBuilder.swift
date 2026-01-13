
import UIKit
import DiiaCommonTypes

public struct DSBtnPrimaryPlainIconBuilder: DSViewBuilderProtocol {
    public let modelKey = "btnPrimaryPlainIconAtm"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSBtnPrimaryPlainIconAtm = object.parseValue(forKey: self.modelKey) else { return nil }
        let view = DSBtnPrimaryPlainIconView()
        view.configure(with: data, eventHandler: eventHandler)
        let paddingBox = BoxView(subview: view).withConstraints(insets: padding.defaultPaddingV2(object: object, modelKey: modelKey))
        return paddingBox
    }
}
