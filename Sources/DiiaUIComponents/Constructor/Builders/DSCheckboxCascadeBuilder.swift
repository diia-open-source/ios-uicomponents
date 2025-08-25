
import Foundation
import UIKit
import DiiaCommonTypes

/// design_system_code: checkboxCascadeOrg

public struct DSCheckboxCascadeBuilder: DSViewBuilderProtocol {
    public let modelKey = "checkboxCascadeOrg"
    
    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let data: DSCheckboxCascadeOrg = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSCheckboxCascadeOrgView()
        let viewModel = DSCheckboxCascadeViewModel(
            componentId: data.componentId ?? self.modelKey,
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
        view.configure(with: viewModel, eventHandler: eventHandler)
        let insets = padding.defaultPadding(object: object, modelKey: modelKey)
        return BoxView(subview: view).withConstraints(insets: insets)
    }
}

extension DSCheckboxCascadeBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSCheckboxCascadeOrg(
            componentId: "componentId",
            inputCode: "cascade_input",
            mandatory: true,
            tableItemCheckboxMlc: DSTableItemCheckboxModel(
                componentId: "componentId",
                inputCode: "parent_checkbox",
                mandatory: true,
                rows: [
                    DSTableItemCheckboxRowModel(
                        textLabelAtm: DSTextLabelAtmModel(
                            componentId: "componentId",
                            mode: .primary,
                            label: "Parent Label",
                            value: "Parent Value"
                        )
                    ),
                    DSTableItemCheckboxRowModel(
                        textLabelAtm: DSTextLabelAtmModel(
                            componentId: "componentId",
                            mode: .secondary,
                            label: "Parent Secondary",
                            value: "Secondary Value"
                        )
                    )
                ],
                isSelected: true,
                isNotFullSelected: false,
                dataJson: "{\"parentData\": true}",
                isEnabled: true
            ),
            items: [
                DSTableItemCheckboxMlc(
                    tableItemCheckboxMlc: DSTableItemCheckboxModel(
                        componentId: "componentId",
                        inputCode: "child_checkbox_1",
                        mandatory: false,
                        rows: [
                            DSTableItemCheckboxRowModel(
                                textLabelAtm: DSTextLabelAtmModel(
                                    componentId: "componentId",
                                    mode: .primary,
                                    label: "Child 1 Label",
                                    value: "Child 1 Value"
                                )
                            )
                        ],
                        isSelected: false,
                        isNotFullSelected: false,
                        dataJson: "{\"childData\": 1}",
                        isEnabled: true
                    )
                ),
                DSTableItemCheckboxMlc(
                    tableItemCheckboxMlc: DSTableItemCheckboxModel(
                        componentId: "componentId",
                        inputCode: "child_checkbox_2",
                        mandatory: false,
                        rows: [
                            DSTableItemCheckboxRowModel(
                                textLabelAtm: DSTextLabelAtmModel(
                                    componentId: "componentId",
                                    mode: .primary,
                                    label: "Child 2 Label",
                                    value: "Child 2 Value"
                                )
                            )
                        ],
                        isSelected: true,
                        isNotFullSelected: false,
                        dataJson: "{\"childData\": 2}",
                        isEnabled: true
                    )
                )
            ],
            isEnabled: true,
            minMandatorySelectedItems: 1
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
