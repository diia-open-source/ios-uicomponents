
import UIKit
import DiiaCommonTypes

/// design_system_code: titleCentralizedMlc
public struct DSTitleCentralizedMlcBuilder: DSViewBuilderProtocol {
    public let modelKey = "titleCentralizedMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTitleCentralizedMlcModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSTitleCentralizedMlcView()
        view.configure(with: data)
        
        let insets = padding.defaultPaddingV2(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSTitleCentralizedMlcBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSTitleCentralizedMlcModel(componentId: "componentId", label: "label")
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
