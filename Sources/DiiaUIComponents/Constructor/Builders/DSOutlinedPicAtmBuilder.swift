
import UIKit
import DiiaCommonTypes

/// design_system_code: outlinedPicAtm
public struct DSOutlinedPicAtmBuilder: DSViewBuilderProtocol {
    public let modelKey = "outlinedPicAtm"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSOutlinedPicAtmModel = object.parseValue(forKey: self.modelKey) else { return nil }

        let view = DSOutlinedPicAtmView()
        view.configure(with: data)
        let padding = paddingType.defaultPaddingV2(object: object, modelKey: modelKey)
        
        let paddingBox = BoxView(subview: view).withConstraints(insets: padding)
        return paddingBox
    }
}
