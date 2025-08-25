
import UIKit
import DiiaCommonTypes

/// design_system_code: tableMainHeadingMlc
public struct DSTableMainHeadingBuilder: DSViewBuilderProtocol {
    public let modelKey = "tableMainHeadingMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTableHeadingItemModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let headingView = DSTableMainHeadingView()
        headingView.configure(with: DSTableMainHeadingViewModel(
            componentId: data.componentId,
            label: data.label,
            description: data.description
        ))
        
        let box = BoxView(subview: headingView).withConstraints(insets: paddingType.insets(for: object, modelKey: modelKey, defaultInsets: .zero))
        return box
    }
}

extension DSTableMainHeadingBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSTableHeadingItemModel(
            label: "label",
            icon: .mock,
            componentId: "componentId",
            description: "description"
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
