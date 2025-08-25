
import UIKit
import DiiaCommonTypes

/// design_system_code: groupFilesAddOrg
public struct DSGroupFilesAddBuilder: DSViewBuilderProtocol {
    public let modelKey = "groupFilesAddOrg"
    
    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let model: DSGroupFilesAddModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSGroupFilesAddView()
        let items = model.items.compactMap { item in
            return DSListItemViewModel(
                id: item.listItemMlc.id,
                title: item.listItemMlc.label,
                details: item.listItemMlc.description,
                rightIcon: UIComponentsConfiguration.shared.imageProvider?.imageForCode(
                    imageCode: item.listItemMlc.iconRight?.code),
                isEnabled: true) {
                    guard let action = item.listItemMlc.action else { return }
                    eventHandler(.action(action))
                }
        }
        view.configure(with: DSGroupFilesAddViewModel(
            componentId: model.componentId,
            items: items,
            buttonAction: Action(
                title: model.btnPlainIconAtm.label,
                iconName: UIComponentsConfiguration.shared.imageProvider?.imageNameForCode(imageCode: model.btnPlainIconAtm.icon)) {
                    guard let action = model.btnPlainIconAtm.action else { return }
                    eventHandler(.action(action))
                }))
        
        let paddingBox = BoxView(subview: view).withConstraints(insets: padding.defaultPadding(object: object, modelKey: modelKey))
        return paddingBox
    }
}

extension DSGroupFilesAddBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let listItem1 = DSListItemModel(listItemMlc: DSListItemMlcModel(
            componentId: "componentId",
            id: "item1",
            label: "Document 1",
            description: "First document description",
            iconRight: DSIconModel.mock,
            action: DSActionParameter.mock,
            type: "file"
        ))
        let listItem2 = DSListItemModel(listItemMlc: DSListItemMlcModel(
            componentId: "componentId",
            id: "item2", 
            label: "Document 2",
            description: "Second document description",
            iconRight: DSIconModel.mock,
            action: nil,
            type: "file"
        ))
        
        let model = DSGroupFilesAddModel(
            componentId: "componentId",
            items: [listItem1, listItem2],
            btnPlainIconAtm: DSBtnPlainIconModel(
                id: "addBtn",
                state: .enabled,
                label: "Add Files",
                icon: "home",
                action: DSActionParameter.mock,
                componentId: "componentId"
            )
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
