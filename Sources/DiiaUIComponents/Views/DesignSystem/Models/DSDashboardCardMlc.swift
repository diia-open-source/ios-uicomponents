
import Foundation

public struct DSDashboardCardMlc: Codable {
    public let componentId: String
    public let type: DSWidgetType
    public let icon: String?
    public let label: String?
    public let amountLarge: String?
    public let amountSmall: String?
    public let description: String?
    public let iconCenter: String?
    public let descriptionCenter: String?
    public let action: DSActionParameter?
    public let btnSemiLightAtm: DSButtonModel?
    
    public init(componentId: String, type: DSWidgetType, icon: String?, label: String?, amountLarge: String?, amountSmall: String?, description: String?, iconCenter: String?, descriptionCenter: String?, action: DSActionParameter?, btnSemiLightAtm: DSButtonModel?) {
        self.componentId = componentId
        self.type = type
        self.icon = icon
        self.label = label
        self.amountLarge = amountLarge
        self.amountSmall = amountSmall
        self.description = description
        self.iconCenter = iconCenter
        self.descriptionCenter = descriptionCenter
        self.action = action
        self.btnSemiLightAtm = btnSemiLightAtm
    }
}

public enum DSWidgetType: String, Codable {
    case empty, button, description
}


