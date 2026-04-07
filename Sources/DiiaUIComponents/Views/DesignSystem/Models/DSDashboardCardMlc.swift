
import Foundation
import DiiaCommonTypes

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
    public let colorMode: DSWidgetColorMode?
    
    public init(componentId: String, type: DSWidgetType, icon: String?, label: String?, amountLarge: String?, amountSmall: String?, description: String?, iconCenter: String?, descriptionCenter: String?, action: DSActionParameter?, btnSemiLightAtm: DSButtonModel?, colorMode: DSWidgetColorMode?) {
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
        self.colorMode = colorMode
    }
}

public enum DSWidgetType: String, Codable {
    case empty, button, description
}

public enum DSWidgetColorMode: String, Codable, EnumDecodable {
    public static var defaultValue: DSWidgetColorMode = .green
    
    case green
    case blue
    case purple
    case orange
    case transparentWhite
}
