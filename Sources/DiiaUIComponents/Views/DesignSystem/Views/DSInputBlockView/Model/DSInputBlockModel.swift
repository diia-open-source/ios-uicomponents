
import DiiaCommonTypes

public struct DSInputBlockModel: Codable {
    public let componentId: String?
    public let tableMainHeadingMlc: DSTableHeadingItemModel?
    public let tableSecondaryHeadingMlc: DSTableHeadingItemModel?
    public let items: [AnyCodable]
    public let attentionIconMessageMlc: DSAttentionIconMessageMlc?
}
