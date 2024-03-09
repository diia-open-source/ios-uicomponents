//
//  DSCardStatusChipModel.swift
//  Diia
//

public struct DSCardStatusChipModel: Codable {
    public let code: String
    public let name: String
    public let type: DSCardStatusChipType
    
    public init(code: String,
                name: String,
                type: DSCardStatusChipType) {
        self.code = code
        self.name = name
        self.type = type
    }
    
    public var statusTextColor: String {
        switch self.type {
        case .fail, .success:
            return AppConstants.Colors.white
        case .neutral, .pending:
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
        }
    }
}

public enum DSCardStatusChipType: String, Codable {
    case success
    case pending
    case fail
    case neutral
}
