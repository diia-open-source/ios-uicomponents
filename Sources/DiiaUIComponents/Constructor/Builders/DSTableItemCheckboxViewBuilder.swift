
import UIKit
import DiiaCommonTypes

/// design_system_code: tableItemCheckboxMlc
public struct DSTableItemCheckboxViewBuilder: DSViewBuilderProtocol {
    public static let modelKey = "tableItemCheckboxMlc"
    
    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let model: DSTableItemCheckboxModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSTableItemCheckboxView()
        let viewModel = DSTableItemCheckboxItemViewModel(model: model)
        viewModel.onClick = { [weak viewModel] in
            guard let viewModel else { return }
            eventHandler(.inputChanged(.init(inputCode: viewModel.inputCode, inputData: .bool(viewModel.isSelected.value))))
        }
        view.configure(with: viewModel)
        
        return view
    }
}
