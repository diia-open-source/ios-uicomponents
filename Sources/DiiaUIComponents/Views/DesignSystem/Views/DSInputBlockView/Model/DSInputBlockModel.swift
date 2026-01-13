
import DiiaCommonTypes

public struct DSInputBlockModel: Codable {
    public let componentId: String?
    public let tableMainHeadingMlc: DSTableHeadingItemModel?
    public let tableSecondaryHeadingMlc: DSTableHeadingItemModel?
    public let items: [AnyCodable]
    public let attentionIconMessageMlc: DSAttentionIconMessageMlc?
    
    public init(componentId: String?,
                tableMainHeadingMlc: DSTableHeadingItemModel?,
                tableSecondaryHeadingMlc: DSTableHeadingItemModel?,
                items: [AnyCodable],
                attentionIconMessageMlc: DSAttentionIconMessageMlc?) {
        self.componentId = componentId
        self.tableMainHeadingMlc = tableMainHeadingMlc
        self.tableSecondaryHeadingMlc = tableSecondaryHeadingMlc
        self.items = items
        self.attentionIconMessageMlc = attentionIconMessageMlc
    }
}
