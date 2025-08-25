
import UIKit
import DiiaCommonTypes

///design_system_code: spacerAtm
public struct SpacerBuilder: DSViewBuilderProtocol {
    public let modelKey = "spacerAtm"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let spacerAtm: SpacerAtm = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let spacer = UIView()
        spacer.backgroundColor = .clear
        spacer.accessibilityIdentifier = spacerAtm.componentId
        spacer.withHeight(spacerAtm.value.height)
        
        return spacer
    }
}

extension SpacerBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = SpacerAtm(
            componentId: "componentId",
            value: .small
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
