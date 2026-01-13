
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
        guard let model: DSCheckboxMlcModel = object.parseValue(forKey: self.modelKey) else { return nil }

        let view = DSCheckboxMlcView()
        let viewModel = DSCheckboxMlcViewModel(model: model)

        viewModel.onClick = { [weak viewModel] in
            guard let viewModel, let inputCode = model.inputCode else { return }
            eventHandler(.inputChanged(.init(inputCode: inputCode, inputData: .bool(viewModel.isSelected.value))))
        }

        view.configure(with: viewModel)

        let box = BoxView(subview: view).withConstraints(insets: padding.insets(for: object, modelKey: modelKey, defaultInsets: .zero))
        return box
    }
}
