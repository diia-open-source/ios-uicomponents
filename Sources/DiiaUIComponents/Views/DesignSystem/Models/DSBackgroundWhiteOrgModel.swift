
import Foundation
import DiiaCommonTypes

public struct DSBackgroundWhiteOrgModel: Codable {
    public let componentId: String?
    public let id: String?
    public let items: [AnyCodable]
    public let count: Int?
    
    public init(componentId: String?, id: String?, items: [AnyCodable], count: Int? = nil) {
        self.componentId = componentId
        self.id = id
        self.items = items
        self.count = count
    }
}
