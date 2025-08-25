
import DiiaCommonTypes

public struct DSTableAccordionOrgModel: Codable {
    public let componentId: String
    public let tableMainHeadingMlc: DSTableHeadingItemModel?
    public let items: [AnyCodable]
    public let attentionIconMessageMlc: DSAttentionIconMessageMlc?
}
