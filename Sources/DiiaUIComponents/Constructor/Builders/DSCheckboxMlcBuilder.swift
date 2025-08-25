
import UIKit
import DiiaCommonTypes

/// design_system_code: checkboxMlc
public struct DSCheckboxMlcBuilder: DSViewBuilderProtocol {
    public let modelKey = "checkboxMlc"
    
    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let model: DSTableItemCheckboxModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSTableItemCheckboxView()
        let viewModel = DSTableItemCheckboxItemViewModel(model: model)
        viewModel.onClick = { [weak viewModel] in
            guard let viewModel else { return }
            eventHandler(.inputChanged(.init(inputCode: viewModel.inputCode, inputData: .bool(viewModel.isSelected.value))))
        }
        view.configure(with: viewModel)
        view.setupUI(titleFont: FontBook.bigText)
        
        let box = BoxView(subview: view).withConstraints(insets: padding.insets(for: object, modelKey: modelKey, defaultInsets: .zero))
        return box
    }
}
