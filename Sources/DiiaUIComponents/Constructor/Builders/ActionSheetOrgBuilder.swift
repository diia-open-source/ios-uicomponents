
import UIKit
import DiiaCommonTypes

///design_system_code: actionSheetOrg
public struct ActionSheetOrgBuilder: DSViewBuilderProtocol {
    public let modelKey = "actionSheetOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let actionSheetOrg: ActionSheetOrg = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let actionSheetOrgView = ActionSheetOrgView()
        actionSheetOrgView.configure(model: actionSheetOrg, eventHandler: eventHandler)
        
        let insets = paddingType.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: actionSheetOrgView).withConstraints(insets: insets)
        
        return paddingBox
    }
}

extension ActionSheetOrgBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let listItem = DSListItemModel(listItemMlc: DSListItemMlcModel(
            componentId: "componentId",
            id: "item1",
            label: "Service 1",
            description: "Service 1 description",
            iconRight: DSIconModel.mock,
            action: DSActionParameter.mock,
            type: "type"
        ))
        let model = ActionSheetOrg(componentId: "actionSheetOrg",
                                   items: [
                                    .dictionary([
                                        "listItemMlc": .fromEncodable(encodable: listItem)
                                    ])
                                   ],
                                   title: "title",
                                   btnWhiteLargeAtm: .mock)
        
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
