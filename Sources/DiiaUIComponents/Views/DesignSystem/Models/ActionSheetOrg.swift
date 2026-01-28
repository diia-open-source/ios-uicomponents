
import DiiaCommonTypes

/// design_system_code: actionSheetOrg
public struct ActionSheetOrg: Codable {
    public let componentId: String
    public let items: [AnyCodable]
    public let title: String?
    public let btnWhiteLargeAtm: DSButtonModel?
    
    public init(componentId: String, items: [AnyCodable], title: String?, btnWhiteLargeAtm: DSButtonModel?) {
        self.componentId = componentId
        self.items = items
        self.title = title
        self.btnWhiteLargeAtm = btnWhiteLargeAtm
    }
}
