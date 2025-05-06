
import Foundation
import UIKit
import DiiaCommonTypes

/// design_system_code: checkboxCascadeOrg

public struct DSCheckboxCascadeBuilder: DSViewBuilderProtocol {
    public static let modelKey = "checkboxCascadeOrg"
    
    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let data: DSCheckboxCascadeOrg = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSCheckboxCascadeOrgView()
        let viewModel = DSCheckboxCascadeViewModel(
            componentId: data.componentId ?? Self.modelKey,
            inputCode: data.inputCode,
            mandatory: data.mandatory,
            tableItemCheckboxMlc: data.tableItemCheckboxMlc,
            items: data.items.compactMap({ $0.tableItemCheckboxMlc }),
            isEnabled: data.isEnabled,
            minMandatorySelectedItems: data.minMandatorySelectedItems)
        viewModel.onChange = { [weak viewModel] in
            guard let viewModel else { return }
            eventHandler(.inputChanged(.init(inputCode: viewModel.inputCode, inputData: viewModel.inputData())))
        }
        view.configure(with: viewModel)
        let insets = padding.defaultPadding()
        return BoxView(subview: view).withConstraints(insets: insets)
    }
}
