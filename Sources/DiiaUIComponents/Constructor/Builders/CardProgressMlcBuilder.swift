
import UIKit
import DiiaCommonTypes

///design_system_code: cardProgressMlc
public struct CardProgressMlcBuilder: DSViewBuilderProtocol {
    public let modelKey = "cardProgressMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let cardProgressMlc: CardProgressMlc = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = CardProgressMlcView()
        view.configure(with: cardProgressMlc, eventHandler: eventHandler)
        let insets = padding.defaultPaddingV2(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        
        return paddingBox
    }
}
