
import DiiaCommonTypes

public struct PaymentInfoOrg: Codable {
    public let componentId: String
    public let title: String
    public let subtitle: String
    public let items: [AnyCodable]
    public let tableItemHorizontalLargeMlc: DSTableItemHorizontalMlc?
    
    public init(
        componentId: String,
        title: String,
        subtitle: String,
        items: [AnyCodable],
        tableItemHorizontalLargeMlc: DSTableItemHorizontalMlc?) {
        self.componentId = componentId
        self.title = title
        self.subtitle = subtitle
        self.items = items
        self.tableItemHorizontalLargeMlc = tableItemHorizontalLargeMlc
    }
}
