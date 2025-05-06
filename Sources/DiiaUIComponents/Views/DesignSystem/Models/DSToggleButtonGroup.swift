
import Foundation

/// design_system_code: toggleButtonGroupOrg
public struct DSToggleButtonGroupModel: Codable {
    public let componentId: String?
    public let items: [DSToggleButtonModel]
    public let preselected: String
    
    public init(
        componentId: String? = nil,
        items: [DSToggleButtonModel],
        preselected: String
    ) {
        self.componentId = componentId
        self.items = items
        self.preselected = preselected
    }
}

/// design_system_code: btnToggleMlc
public struct DSToggleButtonModel: Codable {
    public let btnToggleMlc: DSBtnToggleModel
    
    public init(btnToggleMlc: DSBtnToggleModel) {
        self.btnToggleMlc = btnToggleMlc
    }
}

public struct DSBtnToggleModel: Codable {
    public let code: String
    public let label: String
    public let selected: DSBtnToggleSelection
    public let notSelected: DSBtnToggleSelection
    
    public init(
        code: String,
        label: String,
        selected: DSBtnToggleSelection,
        notSelected: DSBtnToggleSelection
    ) {
        self.code = code
        self.label = label
        self.selected = selected
        self.notSelected = notSelected
    }
}

public struct DSBtnToggleSelection: Codable {
    public let icon: String
    public let action: DSActionParameter?
    
    public init(
        icon: String,
        action: DSActionParameter? = nil
    ) {
        self.icon = icon
        self.action = action
    }
}
