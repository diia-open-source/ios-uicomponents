
import UIKit
import DiiaCommonTypes

/// DS_Code: selectorOrg
public struct DSSelectorOrgBuilder: DSViewBuilderProtocol {
    public let modelKey = "selectorOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSSelectorModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let value = data.value ?? data.selectorListWidgetOrg.items
            .compactMap { $0.searchModel() }
            .first(where: { $0.code == data.valueId })?.title
        let state: DropContentState = (data.valueId != nil) ? .selected(text: value ?? "") : .enabled
        
        let viewModel = DSSelectorViewModel(
            code: data.inputCode ?? data.id ?? self.modelKey,
            state: state,
            title: data.label,
            placeholder: data.placeholder,
            hint: data.hint,
            searchList: data.selectorListWidgetOrg.items,
            searchComponentId: data.selectorListWidgetOrg.componentId,
            selectedCode: data.valueId,
            componentId: data.componentId)
        viewModel.onClick = { [weak viewModel] in
            guard let viewModel = viewModel else { return }
            eventHandler(.dropContentAction(viewModel: viewModel))
        }
        let view = DSSelectorView()
        view.configure(with: viewModel)
        
        if data.isEnabled == false {
            viewModel.state.value = .disabled
        }
        let paddingBox = BoxView(subview: view).withConstraints(insets: padding.defaultPadding(object: object, modelKey: modelKey))
        return paddingBox
    }
}

extension DSSelectorOrgBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSSelectorModel(
            componentId: "componentId",
            inputCode: "inputCode",
            id: "id",
            blocker: nil,
            label: "label",
            placeholder: "placeholder",
            isEnabled: true,
            hint: "hint",
            value: "value",
            valueId: "valueId",
            selectorListWidgetOrg: DSSelectorListWidgetModel(
                items: [
                    DSListWidgetItemsContainer(
                        listWidgetItemMlc: DSListWidgetItemModel(
                            componentId: "componentId",
                            id: "id1",
                            label: "label",
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
                            label: "label",
                            description: "description",
                            iconRight: .mock,
                            action: .mock,
                            type: "type"
                        )
                    )
                ],
                componentId: nil
            )
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
