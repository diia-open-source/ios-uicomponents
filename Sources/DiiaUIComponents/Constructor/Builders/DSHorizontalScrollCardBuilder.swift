
import UIKit
import DiiaCommonTypes

///// design_system_code: cardHorizontalScrollOrg
public struct DSHorizontalScrollCardBuilder: DSViewBuilderProtocol {
    public static let modelKey = "cardHorizontalScrollOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSHorizontalScrollCardData = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSHorizontalScrollCardView()
        view.configure(with: model, eventHandler: eventHandler)
        return view
    }
}
