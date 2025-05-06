
import Foundation
import DiiaCommonTypes

/// design_system_code: chipTimeMlc

public struct DSChipTimeMlc: Codable {
    public let componentId: String?
    public let id: String?
    public let label: String
    public let dataJson: AnyCodable
    public let active: Bool?
    
    public init(componentId: String?, id: String?, label: String, dataJson: AnyCodable, active: Bool?) {
        self.componentId = componentId
        self.id = id
        self.label = label
        self.dataJson = dataJson
        self.active = active
    }
}
