
import Foundation
import DiiaCommonTypes

public struct DSLegendGroup: Codable {
    public let legendGroupMlc: DSLegendGroupMlc
}

public struct DSLegendGroupMlc: Codable {
    public let componentId: String
    public let label: String
    public let isVisible: Bool
    public let type: DSLegendType
}

public enum DSLegendType: String, Codable, EnumDecodable {
    public static var defaultValue: DSLegendType = .initial
    case common, weekend, holiday, initial
}
