
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
        case .fail, .success:
            return AppConstants.Colors.white
        default:
            return AppConstants.Colors.black
        }
    }
    
    public var statusViewColor: String {
        switch self.type {
        case .fail:
            return AppConstants.Colors.persianRed
        case .neutral:
            return AppConstants.Colors.dadaGray
        case .pending:
            return AppConstants.Colors.statusYellow
        case .success:
            return AppConstants.Colors.statusGreen
        case .white:
            return AppConstants.Colors.white
        case .blue:
            return AppConstants.Colors.statusBlue
        }
    }
    
    public var borderColor: UIColor {
        switch self.type {
        case .white:
            return .lightGray
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
