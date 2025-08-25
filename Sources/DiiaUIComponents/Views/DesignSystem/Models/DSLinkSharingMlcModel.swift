
import DiiaCommonTypes

/// design_system_code: linkSharingMlc
public struct DSLinkSharingMlcModel: Codable {
    public let componentId: String
    public let label: String

    public init(componentId: String, label: String) {
        self.componentId = componentId
        self.label = label
    }
}
