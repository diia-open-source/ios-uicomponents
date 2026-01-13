
import DiiaCommonTypes

public struct DSCheckboxGroupOrgModel: Codable {
    public let componentId: String?
    public let inputCode: String?
    public let title: String?
    public let mandatory: Bool?
    public let items: [DSCheckboxGroupOrgItemModel]
    public let minMandatorySelectedItems: Int?

    public init(componentId: String?,
                inputCode: String?,
                title: String?,
                mandatory: Bool?,
                items: [DSCheckboxGroupOrgItemModel],
                minMandatorySelectedItems: Int?) {
        self.componentId = componentId
        self.title = title
        self.inputCode = inputCode
        self.mandatory = mandatory
        self.items = items
        self.minMandatorySelectedItems = minMandatorySelectedItems
    }
}

public struct DSCheckboxGroupOrgItemModel: Codable {
    public let checkboxMlc: DSCheckboxMlcModel?

    public init(checkboxMlc: DSCheckboxMlcModel?) {
        self.checkboxMlc = checkboxMlc
    }
}

public class DSCheckboxGroupOrgViewModel {
    public let model: DSCheckboxGroupOrgModel
    public let items: [DSCheckboxMlcViewModel]
    public var onClick: (() -> Void)?

    public init(model: DSCheckboxGroupOrgModel) {
        let checkboxItems: [DSCheckboxMlcViewModel] = model.items.compactMap {
            guard let model = $0.checkboxMlc else {
                return nil
            }

            return DSCheckboxMlcViewModel(model: model)
        }

        self.model = model
        self.items = checkboxItems
    }

    public func updateSelectionState(forItem selectedItem: DSCheckboxMlcViewModel) {
        selectedItem.isSelected.value.toggle()
        onClick?()
    }

    public func deselectAll(except itemCode: String? = nil) {
        items.forEach {
            if $0.model.inputCode == itemCode { return }
            $0.isSelected.value = false
        }
    }

    public func selectedItems() -> [DSCheckboxMlcViewModel] {
        return items.filter({ $0.isSelected.value && $0.isEnabled.value })
    }
}
