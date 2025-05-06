
import Foundation

public struct DSButtonWhiteAdditionalIconAtm: Codable {
    public let componentId: String?
    public let id: String?
    public let state: DSButtonState?
    public let label: String?
    public let icon: String
    public let accessibilityDescription: String?
    public let badgeCounterAtm: DSBadgeCounterModel?
    public let action: DSActionParameter?
    
    public init(
        id: String? = nil,
        state: DSButtonState? = nil,
        label: String,
        icon: String,
        accessibilityDescription: String?,
        badgeCounterAtm: DSBadgeCounterModel?,
        action: DSActionParameter?,
        componentId: String?
    ) {
        self.id = id
        self.state = state
        self.label = label
        self.icon = icon
        self.accessibilityDescription = accessibilityDescription
        self.action = action
        self.badgeCounterAtm = badgeCounterAtm
        self.componentId = componentId
    }
}
