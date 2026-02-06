
import Foundation

public struct DSTitleCentralizedMlcModel: Codable {
    public let componentId: String
    public let label: String
    
    public init(componentId: String, label: String) {
        self.componentId = componentId
        self.label = label
    }
}
