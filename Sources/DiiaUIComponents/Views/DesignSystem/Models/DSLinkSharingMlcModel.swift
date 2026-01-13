
import DiiaCommonTypes

/// design_system_code: linkSharingMlc
public struct DSLinkSharingMlcModel: Codable {
    public let componentId: String
    public let label: String
    public let iconRight: DSIconModel?
    
    public init(componentId: String, label: String, iconRight: DSIconModel? = nil) {
        self.componentId = componentId
        self.label = label
        self.iconRight = iconRight
    }
}
