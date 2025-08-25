
import UIKit
import DiiaCommonTypes

/// design_system_code: finalScreenBlockMlc
public struct DSFinalScreenBlockBuilder: DSViewBuilderProtocol {
    public let modelKey = "finalScreenBlockMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSFinalScreenBlockMlc = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSFinalScreenBlockView()
        view.configure(
            with: model,
            urlOpener: UIComponentsConfiguration.shared.urlOpener)
        
        let paddingBox = BoxView(subview: view).withConstraints(insets: paddingType.defaultPadding(object: object, modelKey: modelKey))
        return paddingBox
    }
}

extension DSFinalScreenBlockBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSFinalScreenBlockMlc(
            componentId: "componentId",
            extraLargeIconAtm: DSIconModel.mock,
            title: "Final Screen Title",
            subtitle: "This is the subtitle text for the final screen"
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
