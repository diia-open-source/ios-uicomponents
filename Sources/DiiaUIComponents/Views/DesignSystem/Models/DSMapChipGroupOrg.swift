
import Foundation

/// design_system_code: mapChipTabsOrg
public struct DSMapChipGroupOrg: Codable {
    public let componentId: String?
    public let label: String?
    public let preselectedCode: String?
    public let items: [DSMapChipGroupItem]
    
    public init(componentId: String?, label: String?, preselectedCode: String?, items: [DSMapChipGroupItem]) {
        self.componentId = componentId
        self.label = label
        self.preselectedCode = preselectedCode
        self.items = items
    }
}

public struct DSMapChipGroupItem: Codable {
    public let mapChipMlc: DSMapChipMlc?
    public let btnWhiteAdditionalIconAtm: DSButtonWhiteAdditionalIconAtm?
    
    public init(mapChipMlc: DSMapChipMlc? = nil, btnWhiteAdditionalIconAtm: DSButtonWhiteAdditionalIconAtm? = nil) {
        self.mapChipMlc = mapChipMlc
        self.btnWhiteAdditionalIconAtm = btnWhiteAdditionalIconAtm
    }
}

public struct DSMapChipMlc: Codable {
    public let componentId: String?
    public let label: String?
    public let icon: String?
    public let accessibilityDescription: String?
    public var code: String

    public init(componentId: String?, label: String?, icon: String?, accessibilityDescription: String?, code: String) {
        self.componentId = componentId
        self.code = code
        self.label = label
        self.accessibilityDescription = accessibilityDescription
        self.icon = icon
        self.code = code
    }
}
