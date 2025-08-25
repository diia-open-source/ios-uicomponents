
import UIKit
import DiiaCommonTypes

public struct DSButtonIconRoundedGroupBuilder: DSViewBuilderProtocol {
    public let modelKey = "btnIconRoundedGroupOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSButtonIconRoundedGroupModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSButtonIconRoundedGroupView()
        view.configure(with: .init(
            items: data.items,
            touchCallback: { actionParameter in
                eventHandler(.action(actionParameter))
        }))
        
        let paddingBox = BoxView(subview: view).withConstraints(insets: padding.defaultCollectionPadding(object: object, modelKey: modelKey))
        return paddingBox
    }
}

extension DSButtonIconRoundedGroupBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSButtonIconRoundedGroupModel(
            items: [
                DSButtonIconRoundedItem(
                    btnIconRoundedMlc: DSButtonIconRoundedItemModel(
                        label: "Home",
                        icon: "ellipseCross",
                        action: DSActionParameter(
                            type: "button",
                            subtype: "rounded_group",
                            resource: "mock_resource",
                            subresource: "mock_subresource"
                        )
                    )
                ),
                DSButtonIconRoundedItem(
                    btnIconRoundedMlc: DSButtonIconRoundedItemModel(
                        label: "Documents",
                        icon: "ellipseCross",
                        action: DSActionParameter(
                            type: "button",
                            subtype: "rounded_group",
                            resource: "mock_resource",
                            subresource: "mock_subresource"
                        )
                    )
                )
            ]
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
