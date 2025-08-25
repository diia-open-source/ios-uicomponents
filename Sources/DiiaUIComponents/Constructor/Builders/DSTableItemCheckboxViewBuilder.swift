
import UIKit
import DiiaCommonTypes

/// design_system_code: tableItemCheckboxMlc
public struct DSTableItemCheckboxViewBuilder: DSViewBuilderProtocol {
    public let modelKey = "tableItemCheckboxMlc"
    
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
        
        let box = BoxView(subview: view).withConstraints(insets: padding.insets(for: object, modelKey: modelKey, defaultInsets: .zero))
        return box
    }
}

extension DSTableItemCheckboxViewBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSTableItemCheckboxModel(
            componentId: "componentId",
            inputCode: "inputCode",
            mandatory: true,
            rows: [
                DSTableItemCheckboxRowModel(
                    textLabelAtm: DSTextLabelAtmModel(
                        componentId: "componentId(optional)",
                        mode: .primary,
                        label: "label",
                        value: "value(optional)"
                    )
                )
            ],
            isSelected: true,
            isNotFullSelected: true,
            dataJson: "dataJson(optional)",
            isEnabled: true
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
