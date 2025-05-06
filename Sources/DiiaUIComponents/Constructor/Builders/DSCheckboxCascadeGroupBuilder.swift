
import Foundation
import UIKit
import DiiaCommonTypes

/// design_system_code: checkboxCascadeGroupOrg

public struct DSCheckboxCascadeGroupBuilder: DSViewBuilderProtocol {
    public static let modelKey = "checkboxCascadeGroupOrg"
    
    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let data: DSCheckboxCascadeGroupOrg = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSCheckboxCascadeGroupView()
        let viewModel = DSCheckboxCascadeGroupOrgViewModel(
            componentId: data.componentId ?? Self.modelKey,
            inputCode: data.inputCode ?? Self.modelKey,
            mandatory: data.mandatory ?? false,
            minMandatorySelectedItems: data.minMandatorySelectedItems
        )
        
        let items = data.items.map { dataContainer in
            let data = dataContainer.checkboxCascadeOrg
            let itemVM = DSCheckboxCascadeViewModel(
                componentId: data.componentId ?? Self.modelKey,
                inputCode: data.inputCode,
                mandatory: data.mandatory,
                tableItemCheckboxMlc: data.tableItemCheckboxMlc,
                items: data.items.compactMap({ $0.tableItemCheckboxMlc }),
                isEnabled: data.isEnabled,
                minMandatorySelectedItems: data.minMandatorySelectedItems)
            itemVM.onChange = { [weak viewModel] in
                guard let viewModel else { return }
                eventHandler(.inputChanged(.init(inputCode: viewModel.inputCode, inputData: viewModel.inputData())))
            }
            return itemVM
        }
        viewModel.items = items
        
        view.configure(viewModel: viewModel)
        let insets = padding.defaultPadding()
        return BoxView(subview: view).withConstraints(insets: insets)
    }
}
