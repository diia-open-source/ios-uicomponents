
import Foundation
import UIKit
import DiiaCommonTypes

/// design_system_code: checkboxCascadeGroupOrg

public struct DSCheckboxCascadeGroupBuilder: DSViewBuilderProtocol {
    public let modelKey = "checkboxCascadeGroupOrg"
    
    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let data: DSCheckboxCascadeGroupOrg = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSCheckboxCascadeGroupView()
        let viewModel = DSCheckboxCascadeGroupOrgViewModel(
            componentId: data.componentId ?? self.modelKey,
            inputCode: data.inputCode ?? self.modelKey,
            mandatory: data.mandatory ?? false,
            minMandatorySelectedItems: data.minMandatorySelectedItems
        )
        
        let items = data.items.map { dataContainer in
            let data = dataContainer.checkboxCascadeOrg
            let itemVM = DSCheckboxCascadeViewModel(
                componentId: data.componentId ?? self.modelKey,
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
        
        view.configure(viewModel: viewModel, eventHandler: eventHandler)
        let insets = padding.defaultPadding(object: object, modelKey: modelKey)
        return BoxView(subview: view).withConstraints(insets: insets)
    }
}

extension DSCheckboxCascadeGroupBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSCheckboxCascadeGroupOrg(
            componentId: "componentId",
            inputCode: "cascade_group_input",
            mandatory: true,
            items: [
                DSCheckboxCascadeOrgContainer(
                    checkboxCascadeOrg: DSCheckboxCascadeOrg(
                        componentId: "componentId",
                        inputCode: "group_1_input",
                        mandatory: false,
                        tableItemCheckboxMlc: DSTableItemCheckboxModel(
                            componentId: "componentId",
                            inputCode: "group_1_parent",
                            mandatory: false,
                            rows: [
                                DSTableItemCheckboxRowModel(
                                    textLabelAtm: DSTextLabelAtmModel(
                                        componentId: "componentId",
                                        mode: .primary,
                                        label: "Group 1 Parent",
                                        value: "Group 1 Value"
                                    )
                                )
                            ],
                            isSelected: true,
                            isNotFullSelected: false,
                            dataJson: "{\"group\": 1}",
                            isEnabled: true
                        ),
                        items: [
                            DSTableItemCheckboxMlc(
                                tableItemCheckboxMlc: DSTableItemCheckboxModel(
                                    componentId: "componentId",
                                    inputCode: "group_1_child_1",
                                    mandatory: false,
                                    rows: [
                                        DSTableItemCheckboxRowModel(
                                            textLabelAtm: DSTextLabelAtmModel(
                                                componentId: "componentId",
                                                mode: .primary,
                                                label: "Group 1 Child 1",
                                                value: "Child Value 1"
                                            )
                                        )
                                    ],
                                    isSelected: false,
                                    isNotFullSelected: false,
                                    dataJson: "{\"child\": 1}",
                                    isEnabled: true
                                )
                            )
                        ],
                        isEnabled: true,
                        minMandatorySelectedItems: 0
                    )
                ),
                DSCheckboxCascadeOrgContainer(
                    checkboxCascadeOrg: DSCheckboxCascadeOrg(
                        componentId: "componentId",
                        inputCode: "group_2_input",
                        mandatory: false,
                        tableItemCheckboxMlc: DSTableItemCheckboxModel(
                            componentId: "componentId",
                            inputCode: "group_2_parent",
                            mandatory: false,
                            rows: [
                                DSTableItemCheckboxRowModel(
                                    textLabelAtm: DSTextLabelAtmModel(
                                        componentId: "componentId",
                                        mode: .primary,
                                        label: "Group 2 Parent",
                                        value: "Group 2 Value"
                                    )
                                )
                            ],
                            isSelected: false,
                            isNotFullSelected: false,
                            dataJson: "{\"group\": 2}",
                            isEnabled: true
                        ),
                        items: [
                            DSTableItemCheckboxMlc(
                                tableItemCheckboxMlc: DSTableItemCheckboxModel(
                                    componentId: "componentId",
                                    inputCode: "group_2_child_1",
                                    mandatory: false,
                                    rows: [
                                        DSTableItemCheckboxRowModel(
                                            textLabelAtm: DSTextLabelAtmModel(
                                                componentId: "componentId",
                                                mode: .primary,
                                                label: "Group 2 Child 1",
                                                value: "Child Value 2"
                                            )
                                        )
                                    ],
                                    isSelected: true,
                                    isNotFullSelected: false,
                                    dataJson: "{\"child\": 2}",
                                    isEnabled: true
                                )
                            )
                        ],
                        isEnabled: true,
                        minMandatorySelectedItems: 0
                    )
                )
            ],
            minMandatorySelectedItems: 1
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
