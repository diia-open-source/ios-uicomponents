
import Foundation

public struct DSBtnIconPlainGroupMlc: Codable {
    public let items: [DSBtnPlainIconAtm]
    public let componentId: String?
    
    public init(items: [DSBtnPlainIconAtm], componentId: String?) {
        self.items = items
        self.componentId = componentId
    }
}

public struct DSBtnPlainIconAtm: Codable {
    public let btnPlainIconAtm: DSBtnPlainIconModel
    
    public init(btnPlainIconAtm: DSBtnPlainIconModel) {
        self.btnPlainIconAtm = btnPlainIconAtm
    }
}

public struct DSBtnLoadPlainGroupMlc: Codable {
    public let items: [DSBtnLoadPlainIconAtm]
    public let componentId: String?
    
    public init(items: [DSBtnLoadPlainIconAtm], componentId: String?) {
        self.items = items
        self.componentId = componentId
    }
}

public struct DSBtnLoadPlainIconAtm: Codable {
    public let btnLoadPlainIconAtm: DSBtnPlainIconModel
    
    public init(btnLoadPlainIconAtm: DSBtnPlainIconModel) {
        self.btnLoadPlainIconAtm = btnLoadPlainIconAtm
    }
}

public struct DSBtnPlainIconModel: Codable {
    public let componentId: String?
    public let id: String?
    public let state: DSButtonState?
    public let label: String
    public let icon: String
    public let action: DSActionParameter?
    
    public init(
        id: String? = nil,
        state: DSButtonState? = nil,
        label: String,
        icon: String,
        action: DSActionParameter?,
        componentId: String?
    ) {
        self.id = id
        self.state = state
        self.label = label
        self.icon = icon
        self.action = action
        self.componentId = componentId
    }
    
    static let mock = DSBtnPlainIconModel(
        id: "id",
        state: .enabled,
        label: "label",
        icon: "icon",
        action: .mock,
        componentId: "componentId"
    )
}
