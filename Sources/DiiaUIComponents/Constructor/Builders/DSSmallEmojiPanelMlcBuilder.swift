import UIKit
import DiiaCommonTypes

/// design_system_code: smallEmojiPanelMlc
public struct DSSmallEmojiPanelMlcBuilder: DSViewBuilderProtocol {
    public let modelKey = "smallEmojiPanelMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSSmallEmojiPanelMlcl = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = SmallButtonPanelMlcView()
        view.configure(for: data, color: .white)
        return BoxView(subview: view).withConstraints(insets: paddingType.defaultPadding(object: object, modelKey: modelKey))
    }
}

extension DSSmallEmojiPanelMlcBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSSmallEmojiPanelMlcl(label: "label", icon: .mock)
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
