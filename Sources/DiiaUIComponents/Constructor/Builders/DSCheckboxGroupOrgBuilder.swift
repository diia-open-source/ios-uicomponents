
import UIKit
import DiiaCommonTypes

public struct DSCheckboxGroupOrgBuilder: DSViewBuilderProtocol {
    public let modelKey = "checkboxGroupOrg"

    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSCheckboxGroupOrgModel = object.parseValue(forKey: self.modelKey) else { return nil }

        let viewModel = DSCheckboxGroupOrgViewModel(model: model)

        viewModel.onClick = { [weak viewModel] in
            guard let viewModel else { return }
            let selectedItems = viewModel.selectedItems()
            eventHandler(.inputChanged(.init(
                inputCode: model.inputCode ?? self.modelKey,
                inputData: .array(selectedItems.map { .string($0.model.id) }))))
        }

        let view = DSCheckboxGroupOrgView()
        view.configure(with: viewModel, eventHandler: eventHandler)

        let insets = paddingType.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSCheckboxGroupOrgBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSCheckboxGroupOrgModel(
            componentId: "componentId",
            inputCode: "checkbox_group_inputCode",
            title: "Mock Checkbox Group Title",
            mandatory: true,
            items: [
                DSCheckboxGroupOrgItemModel(
                    checkboxMlc: DSCheckboxMlcModel(
                        id: "id",
                        label: "Second round checkbox",
                        componentId: "componentId",
                        inputCode: "inputCode",
                        description: "Description for second checkbox",
                        isSelected: nil,
                        isEnabled: true
                    )
                ),
                DSCheckboxGroupOrgItemModel(
                    checkboxMlc: DSCheckboxMlcModel(
                        id: "id",
                        label: "Second round checkbox",
                        componentId: "componentId",
                        inputCode: "inputCode",
                        description: "Description for second checkbox",
                        isSelected: nil,
                        isEnabled: false
                    )
                ),
                DSCheckboxGroupOrgItemModel(
                    checkboxMlc: DSCheckboxMlcModel(
                        id: "id",
                        label: "Second round checkbox",
                        componentId: "componentId",
                        inputCode: "inputCode",
                        description: nil,
                        isSelected: false,
                        isEnabled: true
                    )
                ),
                DSCheckboxGroupOrgItemModel(
                    checkboxMlc: DSCheckboxMlcModel(
                        id: "id",
                        label: "Second round checkbox",
                        componentId: "componentId",
                        inputCode: "inputCode",
                        description: "Description for second checkbox",
                        isSelected: true,
                        isEnabled: true
                    )
                ),
                DSCheckboxGroupOrgItemModel(
                    checkboxMlc: DSCheckboxMlcModel(
                        id: "id",
                        label: "Second round checkbox",
                        componentId: "componentId",
                        inputCode: "inputCode",
                        description: "Description for second checkbox",
                        isSelected: true,
                        isEnabled: false
                    )
                ),
                DSCheckboxGroupOrgItemModel(
                    checkboxMlc: DSCheckboxMlcModel(
                        id: "id",
                        label: "Second round checkbox",
                        componentId: "componentId",
                        inputCode: "inputCode",
                        description: nil,
                        isSelected: true,
                        isEnabled: true
                    )
                ),
                DSCheckboxGroupOrgItemModel(
                    checkboxMlc: DSCheckboxMlcModel(
                        id: "id",
                        label: "Second round checkbox",
                        componentId: "componentId",
                        inputCode: "inputCode",
                        description: "Description for second checkbox",
                        isSelected: nil,
                        isEnabled: nil
                    )
                )
            ],
            minMandatorySelectedItems: 2
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
