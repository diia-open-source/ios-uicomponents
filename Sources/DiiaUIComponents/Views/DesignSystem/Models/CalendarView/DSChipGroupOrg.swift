
import Foundation

/// design_system_code: chipGroupOrg

public struct DSChipGroupOrg: Codable {
    public let componentId: String?
    public let label: String?
    public let preselectedCode: String?
    public let items: [DSChipItemMlc]
    
    public init(componentId: String?, label: String?, preselectedCode: String?, items: [DSChipItemMlc]) {
        self.componentId = componentId
        self.label = label
        self.preselectedCode = preselectedCode
        self.items = items
    }
}

public struct DSChipItemMlc: Codable {
    public let chipMlc: DSChipMlc?
    public let chipTimeMlc: DSChipTimeMlc?
    
    public init(chipMlc: DSChipMlc? = nil, chipTimeMlc: DSChipTimeMlc? = nil) {
        self.chipMlc = chipMlc
        self.chipTimeMlc = chipTimeMlc
    }
}

public struct DSChipMlc: Codable {
    public let componentId: String?
    public let label: String
    public let code: String
    public let badgeCounterAtm: DSBadgeCounterModel?
    public let iconLeft: DSIconModel?
    public let active: Bool?
    public let selectedIcon: String?
    public let isSelectable: Bool?
    public let chipInfo: DSChipInfo?
    public let action: DSActionParameter?
    
    public init(
        componentId: String?,
        label: String,
        code: String,
        badgeCounterAtm: DSBadgeCounterModel?,
        iconLeft: DSIconModel?,
        active: Bool?,
        selectedIcon: String?,
        isSelectable: Bool?,
        chipInfo: DSChipInfo?,
        action: DSActionParameter?
    ) {
        self.componentId = componentId
        self.label = label
        self.code = code
        self.badgeCounterAtm = badgeCounterAtm
        self.iconLeft = iconLeft
        self.active = active
        self.selectedIcon = selectedIcon
        self.isSelectable = isSelectable
        self.chipInfo = chipInfo
        self.action = action
    }
}

public struct DSChipInfo: Codable {
    public let hallId: String
    
    public init(hallId: String) {
        self.hallId = hallId
    }
}

public struct DSBadgeCounterModel: Codable {
    public let count: Int
    
    public init(count: Int) {
        self.count = count
    }
}
