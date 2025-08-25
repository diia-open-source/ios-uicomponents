
import DiiaCommonTypes

public struct DSTextBlockV2Model: Codable {
    public let componentId: String
    public let chipStatusAtm: DSCardStatusChipModel?
    public let tableMainHeadingMlc: DSTableHeadingItemModel?
    public let tableSecondaryHeadingMlc: DSTableHeadingItemModel?
    public let items: [AnyCodable]
    public let attentionIconMessageMlc: DSAttentionIconMessageMlc?
    
    public init(componentId: String, chipStatusAtm: DSCardStatusChipModel?, tableMainHeadingMlc: DSTableHeadingItemModel?, tableSecondaryHeadingMlc: DSTableHeadingItemModel?, items: [AnyCodable], attentionIconMessageMlc: DSAttentionIconMessageMlc?) {
        self.componentId = componentId
        self.chipStatusAtm = chipStatusAtm
        self.tableMainHeadingMlc = tableMainHeadingMlc
        self.tableSecondaryHeadingMlc = tableSecondaryHeadingMlc
        self.items = items
        self.attentionIconMessageMlc = attentionIconMessageMlc
    }
}

