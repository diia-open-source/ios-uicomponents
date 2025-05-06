
import DiiaCommonTypes
import UIKit

/// DS_Code: grayTitleAtm

public struct DSGrayTitleAtmBulder: DSViewBuilderProtocol {
    
    public static let modelKey = "greyTitleAtm"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSGreyTitleAtmModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        let view = DSGreyTitleAtm()
        view.configure(with: data)
        
        return view
    }
}
