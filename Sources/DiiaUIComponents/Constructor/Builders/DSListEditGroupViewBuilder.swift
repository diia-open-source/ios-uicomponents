
import UIKit
import DiiaCommonTypes

/// design_system_code: listItemEditGroupOrg
public struct DSListEditGroupViewBuilder: DSViewBuilderProtocol {
    public static let modelKey = "listItemEditGroupOrg"
    
    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let model: DSListEditGroupModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSListEditGroupView()
        let items = model.items
        
        let viewModel = DSListEditGroupViewModel(
            componentId: model.componentId,
            inputCode: model.inputCode,
            title: model.title,
            description: model.description,
            items: items,
            buttonAction: model.btnPlainIconAtm,
            eventHandler: eventHandler
        )
        
        view.configure(with: viewModel)
        
        let paddingBox = BoxView(subview: view).withConstraints(insets: padding.defaultPadding())
        return paddingBox
    }
}
