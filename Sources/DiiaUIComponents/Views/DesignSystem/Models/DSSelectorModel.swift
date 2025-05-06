
import DiiaCommonTypes

public struct DSSelectorModel: Codable {
    public let componentId: String?
    public let inputCode: String?
    public let id: String?
    public let blocker: Bool?
    public let label: String
    public let placeholder: String
    public let isEnabled: Bool?
    public let hint: String?
    public let value: String?
    public let valueId: String?
    public let selectorListWidgetOrg: DSSelectorListWidgetModel
}

public struct DSSelectorListWidgetModel: Codable {
    public let items: [DSListWidgetItemsContainer]
    public let componentId: String?
}

public struct DSListWidgetItemsContainer: Codable {
    public let listWidgetItemMlc: DSListWidgetItemModel?
    public let listItemMlc: DSListItemMlcModel?
    
    public func searchModel() -> SearchItemModel? {
        if let listWidgetItemMlc {
            return SearchItemModel(
                code: listWidgetItemMlc.id ?? "",
                title: listWidgetItemMlc.label,
                additionalText: listWidgetItemMlc.description,
                isEnabled: listWidgetItemMlc.state != "disabled",
                componentId: listWidgetItemMlc.componentId
            )
        } else if let listItemMlc {
            return SearchItemModel(
                code: listItemMlc.id ?? "",
                title: listItemMlc.label,
                additionalText: listItemMlc.description,
                componentId: listItemMlc.componentId
            )
        }

        return nil
    }
}
