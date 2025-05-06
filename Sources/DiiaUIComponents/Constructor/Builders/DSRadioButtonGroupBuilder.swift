
import UIKit
import DiiaCommonTypes

public struct DSRadioButtonGroupBuilder: DSViewBuilderProtocol {
    public static let modelKey = "radioBtnGroupOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSRadioBtnGroupOrg = object.parseValue(forKey: Self.modelKey) else { return nil }
        return makeView(from: data, withPadding: paddingType, eventHandler: eventHandler)
    }
    
    func makeView(from data: DSRadioBtnGroupOrg,
                  withPadding paddingType: DSViewPaddingType,
                  eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        let view = ChecklistView()
        let checkboxItems: [ChecklistItemViewModel] = data.items.map {
            let item = $0.radioBtnMlc
            return ChecklistItemViewModel(
                code: item.id,
                title: item.label,
                details: item.description,
                rightInfo: item.status,
                largeLogoRight: item.largeLogoRight,
                isAvailable: item.isEnabled ?? true,
                isSelected: item.isSelected ?? false,
                inputData: item.dataJson,
                componentId: item.componentId)
        }
        
        // If one enabled item in array, then select that item
        let availableItems = checkboxItems.filter({ $0.isAvailable })
        if availableItems.count == 1 {
            availableItems.first?.isSelected = true
        }
        
        var plainButtonAction: Action?
        if let btnPlainIcon = data.btnPlainIconAtm {
            plainButtonAction = Action(
                title: btnPlainIcon.label,
                iconName: UIComponentsConfiguration.shared.imageProvider?.imageNameForCode(imageCode: btnPlainIcon.icon)) {
                    if let action = btnPlainIcon.action {
                        eventHandler(.action(action))
                    }
                }
        }
        
        let viewModel = ChecklistViewModel(
            title: data.title,
            items: checkboxItems,
            plainButton: plainButtonAction,
            checklistType: .single(checkboxStyle: .radioButton),
            componentId: data.componentId,
            inputCode: data.inputCode,
            mandatory: data.mandatory)
        viewModel.onClick = { [weak viewModel] in
            guard let viewModel = viewModel else { return }
            let selectedItems = viewModel.selectedItems()
            eventHandler(.inputChanged(.init(
                inputCode: data.inputCode ?? Self.modelKey,
                inputData: .array(selectedItems.map { .string($0.code ?? "") }))))
        }
        view.configure(with: viewModel)
        eventHandler(.onComponentConfigured(with: .checkmark(viewModel: viewModel)))
        let insets = paddingType.defaultPadding()
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}
