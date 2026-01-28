
public struct ScanModalCardOrg: Codable {
    public let componentId: String
    public let title: String
    public let chipStatusAtm: DSCardStatusChipModel?
    public let description: String?
    public let tableItems: [DSTableItem]?
    public let attentionIconMessageMlc: DSAttentionIconMessageMlc?
    public let items: [DSListItem]?
    public let mediumIconAtm: DSIconModel?
    
    public init(componentId: String, title: String, chipStatusAtm: DSCardStatusChipModel?, description: String?, tableItems: [DSTableItem]?, attentionIconMessageMlc: DSAttentionIconMessageMlc?, items: [DSListItem]?, mediumIconAtm: DSIconModel?) {
        self.componentId = componentId
        self.title = title
        self.chipStatusAtm = chipStatusAtm
        self.description = description
        self.tableItems = tableItems
        self.attentionIconMessageMlc = attentionIconMessageMlc
        self.items = items
        self.mediumIconAtm = mediumIconAtm
    }
}

public struct DSListItem: Codable {
    public let listItemMlc: DSListGroupItem
}
