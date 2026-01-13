
import UIKit
import DiiaCommonTypes

/// DS_Code: selectorOrgV2
public struct DSSelectorOrgV2Builder: DSViewBuilderProtocol {
    public let modelKey = "selectorOrgV2"

    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSSelectorOrgV2Model = object.parseValue(forKey: self.modelKey) else { return nil }

        let label = label(model: model)
        let state = state(isEnabled: model.isEnabled ?? true, label: label)

        let viewModel = DSSelectorViewModel(
            inputCode: model.inputCode ?? self.modelKey,
            state: state,
            title: model.label,
            mandatory: model.mandatory,
            placeholder: model.placeholder,
            hint: model.hint,
            searchList: model.searchScreenData?.items ?? [],
            selectedCode: model.valueId,
            componentId: model.componentId)

        viewModel.onClick = { [weak viewModel] in
            if let action = model.action {
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

    // MARK: - Private
    private func label(model: DSSelectorOrgV2Model) -> String? {
        return model.value ?? model.searchScreenData?.items
            .compactMap { $0.searchModel() }
            .first(where: { $0.code == model.valueId })?.title
    }

    private func state(isEnabled: Bool, label: String?) -> DropContentState {
        if let label {
            return isEnabled ? .selected(text: label) : .single(text: label)
        } else {
            return isEnabled ? .enabled : .disabled
        }
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
            valueId: "valueId",
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
