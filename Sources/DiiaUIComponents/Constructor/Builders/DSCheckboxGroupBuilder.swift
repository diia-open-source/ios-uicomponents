
import UIKit
import DiiaCommonTypes

public struct DSCheckboxGroupBuilder: DSViewBuilderProtocol {
    public let modelKey = "checkboxRoundGroupOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSCheckboxRoundGroupOrg = object.parseValue(forKey: self.modelKey) else { return nil }
        var checkboxItems: [ChecklistItemViewModel] = []
        data.items.forEach {
            if let checkboxRoundMlc = $0.checkboxRoundMlc {
                var isSelected = false
                var isAvailable = true
                
                if checkboxRoundMlc.state != nil {
                    isSelected = checkboxRoundMlc.state == .selected || checkboxRoundMlc.state == .disableSelected
                    isAvailable = checkboxRoundMlc.state == .rest || checkboxRoundMlc.state == .selected
                }
                
                let item = ChecklistItemViewModel(code: checkboxRoundMlc.id,
                                                  title: checkboxRoundMlc.label,
                                                  details: checkboxRoundMlc.description,
                                                  isAvailable: isAvailable,
                                                  isSelected: isSelected)
                checkboxItems.append(item)
            }
        }
        let viewModel = ChecklistViewModel(
            title: data.title,
            items: checkboxItems,
            checklistType: .multiple(checkboxStyle: .radioCheckmark),
            inputCode: data.inputCode,
            mandatory: data.mandatory)
        viewModel.onClick = { [weak viewModel] in
            guard let viewModel = viewModel else { return }
            let selectedItems = viewModel.selectedItems()
            eventHandler(.inputChanged(.init(
                inputCode: data.inputCode ?? self.modelKey,
                inputData: .array(selectedItems.map { .string($0.code ?? "") }))))
        }
        
        let view = ChecklistView()
        view.configure(with: viewModel, eventHandler: eventHandler)
        
        let insets = paddingType.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSCheckboxGroupBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSCheckboxRoundGroupOrg(
            componentId: "componentId",
            title: "Mock Checkbox Group Title",
            inputCode: "checkbox_round_group",
            mandatory: true,
            items: [
                DSCheckboxRoundItem(
                    checkboxRoundMlc: DSCheckboxRoundMlc(
                        id: "round_checkbox_1",
                        iconLeft: "home",
                        label: "First round checkbox",
                        description: "Description for first checkbox",
                        action: DSActionParameter.mock,
                        state: .selected
                    )
                ),
                DSCheckboxRoundItem(
                    checkboxRoundMlc: DSCheckboxRoundMlc(
                        id: "round_checkbox_2",
                        iconLeft: "info",
                        label: "Second round checkbox",
                        description: "Description for second checkbox",
                        action: DSActionParameter.mock,
                        state: .rest
                    )
                ),
                DSCheckboxRoundItem(
                    checkboxRoundMlc: DSCheckboxRoundMlc(
                        id: "round_checkbox_3",
                        iconLeft: "homedoc",
                        label: "Third round checkbox",
                        description: "Description for third checkbox",
                        action: DSActionParameter.mock,
                        state: .disable
                    )
                )
            ]
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
