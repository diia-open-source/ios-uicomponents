
import Foundation

public struct DSCardMlcV2Model: Codable {
    public let componentId: String?
    public let chipStatusAtm: DSCardStatusChipModel?
    public let label: String
    public let descriptions: [String]?
    public let chips: [DSCardStatusChipMlc]?
    public let iconUrlAtm: DSIconUrlAtmModel?
    public let action: DSActionParameter?
    
    public init(componentId: String?,
                chipStatusAtm: DSCardStatusChipModel?,
                label: String,
                descriptions: [String]?,
                chips: [DSCardStatusChipMlc]?,
                iconUrlAtm: DSIconUrlAtmModel?,
                action: DSActionParameter?) {
        self.componentId = componentId
        self.chipStatusAtm = chipStatusAtm
        self.label = label
        self.descriptions = descriptions
        self.chips = chips
        self.iconUrlAtm = iconUrlAtm
        self.action = action
    }
}

public struct DSCardStatusChipMlc: Codable {
    public let chipStatusAtm: DSCardStatusChipModel
    
    public init(chipStatusAtm: DSCardStatusChipModel) {
        self.chipStatusAtm = chipStatusAtm
    }
}
