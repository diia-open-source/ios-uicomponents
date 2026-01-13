
import UIKit
import DiiaCommonTypes

public struct DSRadioButtonGroupBuilder: DSViewBuilderProtocol {
    public let modelKey = "radioBtnGroupOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard
            let data: DSRadioBtnGroupOrg = object.parseValue(forKey: self.modelKey),
            let view = makeView(from: data, eventHandler: eventHandler)
        else {
            return nil
        }
        let box = BoxView(subview: view).withConstraints(insets: paddingType.defaultPadding(object: object, modelKey: modelKey))
        return box
    }
    
    func makeView(from data: DSRadioBtnGroupOrg,
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
                logoRight: item.logoRight,
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
                iconName: UIComponentsConfiguration.shared.imageProvider.imageNameForCode(imageCode: btnPlainIcon.icon)) {
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
                inputCode: data.inputCode ?? self.modelKey,
                inputData: .array(selectedItems.map { .string($0.code ?? "") }))))
        }
        view.configure(with: viewModel, eventHandler: eventHandler)
        return view
    }
}

extension DSRadioButtonGroupBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSRadioBtnGroupOrg(
            id: "radioBtnGroupOrg",
            blocker: nil,
            title: "title(otional)",
            condition: nil,
            items: [
                DSRadioGroupItem(
                    condition: nil,
                    radioBtnMlc: DSRadioButtonMlc(
                        id: "id1",
                        label: "label",
                        status: "status",
                        type: .rest,
                        additionalInfo: DSRadioButtonAdditionalInfo(
                            label: "label",
                            placeholder: "placeholder",
                            value: "value(optiona)",
                            validation: InputValidationModel(regexp: "^([a-zA-Z0-9_%+-]{1,}\\.){0,}[a-zA-Z0-9_%+-]{1,}@([a-zA-Z0-9_%+-]{1,}\\.){1,}(?!ru|su)[A-Za-z]{2,64}$", flags: ["i"], errorMessage: "Невалідний емейл")
                        ),
                        componentId: "componentId",
                        logoLeft: "logoLeft(optional)",
                        logoRight: "logoRight(optional)",
                        largeLogoRight: "largeLogoRight(optional)",
                        description: "description(optional)",
                        isSelected: false,
                        isEnabled: true,
                        dataJson: .string("dataJson1(optional)")
                    )
                ),
                DSRadioGroupItem(
                    condition: nil,
                    radioBtnMlc: DSRadioButtonMlc(
                        id: "id2",
                        label: "label2",
                        status: "status",
                        type: .rest,
                        additionalInfo: DSRadioButtonAdditionalInfo(
                            label: "label",
                            placeholder: "placeholder",
                            value: "value(optiona)",
                            validation: InputValidationModel(regexp: "^([a-zA-Z0-9_%+-]{1,}\\.){0,}[a-zA-Z0-9_%+-]{1,}@([a-zA-Z0-9_%+-]{1,}\\.){1,}(?!ru|su)[A-Za-z]{2,64}$", flags: ["i"], errorMessage: "Невалідний емейл")
                        ),
                        componentId: "componentId",
                        logoLeft: "logoLeft(optional)",
                        logoRight: "logoRight(optional)",
                        largeLogoRight: "largeLogoRight(optional)",
                        description: "description(optional)",
                        isSelected: true,
                        isEnabled: true,
                        dataJson: .string("dataJson2(optional)")
                    )
                )
            ],
            componentId: "componentId",
            inputCode: "inputCode",
            mandatory: true,
            btnPlainIconAtm: .mock
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
