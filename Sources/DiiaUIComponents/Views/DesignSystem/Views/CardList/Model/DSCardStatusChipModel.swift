
import UIKit

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
        case .neutral, .pending, .white:
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
}

public enum DSCardStatusChipType: String, Codable, Equatable {
    case success, pending, fail, neutral, white
}
