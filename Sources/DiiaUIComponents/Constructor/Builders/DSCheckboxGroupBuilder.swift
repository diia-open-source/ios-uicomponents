
import UIKit
import DiiaCommonTypes

public struct DSCheckboxGroupBuilder: DSViewBuilderProtocol {
    public static let modelKey = "checkboxRoundGroupOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSCheckboxRoundGroupOrg = object.parseValue(forKey: Self.modelKey) else { return nil }
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
                inputCode: data.inputCode ?? Self.modelKey,
                inputData: .array(selectedItems.map { .string($0.code ?? "") }))))
        }
        
        let view = ChecklistView()
        view.configure(with: viewModel)
        
        let insets = paddingType.defaultPadding()
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}
