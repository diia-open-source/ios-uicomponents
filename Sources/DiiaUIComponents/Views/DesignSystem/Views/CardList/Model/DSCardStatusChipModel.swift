
import UIKit
import DiiaCommonTypes

public struct DSCardStatusChipModel: Codable, Equatable {
    public let code: String
    public let name: String
    public let type: DSCardStatusChipType
    public let componentId: String?
    
    public init(code: String,
                name: String,
                type: DSCardStatusChipType,
                componentId: String?) {
        self.code = code
        self.name = name
        self.type = type
        self.componentId = componentId
    }
    
    public var statusTextColor: String {
        switch self.type {
        case .fail:
            return "#820812"
        case .neutral:
            return "#000000CC"
        case .pending:
            return "#4E3403"
        case .success:
            return "#075313"
        case .white:
            return "#000000"
        case .blue:
            return "#073360"
        }
    }
    
    public var statusViewColor: String {
        switch self.type {
        case .fail:
            return "#FED7D9"
        case .neutral:
            return "#0000001A"
        case .pending:
            return "#FEF1A4"
        case .success:
            return "#C5F1CC"
        case .white:
            return "#FFFFFF"
        case .blue:
            return "#CCE5FF"
        }
    }
    
    public var borderColor: UIColor {
        switch self.type {
        case .white:
            return .init("#0000004C")
        default:
            return .clear
        }
    }
    
    static let mock = DSCardStatusChipModel(
        code: "code",
        name: "name",
        type: .blue,
        componentId: "componentId"
    )
}

public enum DSCardStatusChipType: String, Codable, Equatable, EnumDecodable {
    public static let defaultValue: DSCardStatusChipType = .neutral
    
    case success, pending, fail, neutral, white, blue
}
