
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
        
        let label = UILabel().withParameters(font: FontBook.mainFont.regular.size(Constants.labelFontSize), numberOfLines: 0, textAlignment: .center)
        label.accessibilityIdentifier = data.componentId
        label.text = data.label
        
        let insets = padding.defaultPaddingV2(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: label).withConstraints(insets: insets)
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

// MARK: - Constants
private extension DSTitleCentralizedMlcBuilder {
    enum Constants {
        static let labelFontSize: CGFloat = 21
    }
}
