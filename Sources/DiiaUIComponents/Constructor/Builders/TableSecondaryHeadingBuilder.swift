
import UIKit
import DiiaCommonTypes

/// design_system_code: tableSecondaryHeadingMlc
public struct TableSecondaryHeadingBuilder: DSViewBuilderProtocol {
    public let modelKey = "tableSecondaryHeadingMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTableHeadingItemModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let headingView = TableSecondaryHeadingView()
        let viewModel = TableSecondaryHeadingViewModel(headingModel: data)
        headingView.configure(with: viewModel) {
            if let iconAction = data.icon?.action {
                eventHandler(.action(iconAction))
            }
        }
        
        return BoxView(subview: headingView).withConstraints(insets: paddingType.defaultPadding(object: object, modelKey: modelKey))
    }
}

extension TableSecondaryHeadingBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSTableHeadingItemModel(
            label: "label",
            icon: DSIconModel(
                code: "code",
                accessibilityDescription: "accessibilityDescription",
                componentId: "componentId",
                action: DSActionParameter(
                    type: "iconAction",
                    subtype: "subtype",
                    resource: "resource",
                    subresource: "subresource"),
                isEnable: true
            ),
            componentId: "componentId",
            description: "description"
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
