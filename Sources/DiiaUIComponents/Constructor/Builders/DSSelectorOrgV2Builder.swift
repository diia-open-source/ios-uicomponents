
import UIKit
import DiiaCommonTypes

/// DS_Code: selectorOrgV2
public struct DSSelectorOrgV2Builder: DSViewBuilderProtocol {
    public let modelKey = "selectorOrgV2"

    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSSelectorOrgV2Model = object.parseValue(forKey: self.modelKey) else { return nil }

        var state: DropContentState {
            guard data.isEnabled ?? true else { return .disabled }

            let searchModels = data.searchScreenData?.items.compactMap { $0.searchModel() }

            if let searchModels, let valueId = data.valueId, let item = searchModels.first(where: { $0.code == valueId }) {
                return .selected(text: item.title)
            } else {
                return .selected(text: data.value ?? "")
            }
        }

        let viewModel = DSSelectorViewModel(
            code: data.inputCode ?? self.modelKey,
            state: state,
            title: data.label,
            mandatory: data.mandatory,
            placeholder: data.placeholder,
            hint: data.hint,
            searchList: data.searchScreenData?.items ?? [],
            searchComponentId: data.valueId,
            selectedCode: data.valueId,
            componentId: data.componentId)

        viewModel.onClick = { [weak viewModel] in
            if let action = data.action {
                eventHandler(.action(action))
            } else if let viewModel {
                eventHandler(.dropContentAction(viewModel: viewModel))
            }
        }

        let view = DSSelectorOrgV2View()
        view.configure(with: viewModel)

        let paddingBox = BoxView(subview: view).withConstraints(insets: padding.defaultPadding(object: object, modelKey: modelKey))
        return paddingBox
    }
}

extension DSSelectorOrgV2Builder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSSelectorOrgV2Model(
            componentId: "componentId",
            inputCode: "inputCode",
            mandatory: true,
            label: "label",
            placeholder: "placeholder",
            hint: "hint",
            valueId: "id1",
            value: "value",
            isEnabled: true,
            searchScreenData: DSSearchScreenDataModel(
                searchScreenTitle: "searchScreenTitle",
                searchPlaceholder: "searchPlaceholder",
                items: [
                    DSListWidgetItemsContainer(
                        listWidgetItemMlc: DSListWidgetItemModel(
                            componentId: "componentId",
                            id: "id1",
                            label: "listWidgetItemMlc label",
                            description: "description",
                            iconLeft: "iconLeft",
                            iconRight: "iconRight",
                            state: "state",
                            dataJson: .string("dataJson")
                        ),
                        listItemMlc: nil
                    ),
                    DSListWidgetItemsContainer(
                        listWidgetItemMlc: nil,
                        listItemMlc: DSListItemMlcModel(
                            componentId: "componentId",
                            id: "id2",
                            label: "listItemMlc label",
                            description: "description",
                            iconRight: .mock,
                            action: .mock,
                            type: "type"
                        )
                    )
                ],
                paginationMessageMlc: .mock
            ),
            action: DSActionParameter.mock
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
