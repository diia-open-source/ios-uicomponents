
import UIKit
import DiiaCommonTypes

/// design_system_code: groupFilesAddOrg
public struct DSGroupFilesAddBuilder: DSViewBuilderProtocol {
    public static let modelKey = "groupFilesAddOrg"
    
    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let model: DSGroupFilesAddModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
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
        
        let paddingBox = BoxView(subview: view).withConstraints(insets: padding.defaultPadding())
        return paddingBox
    }
}
