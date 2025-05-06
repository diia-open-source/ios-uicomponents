
import Foundation

public struct DSRadioBtnWithAltOrg: Codable {
    public let componentId: String
    public let items: [DSRadioBtnGroupItem]
    
    public init(componentId: String, items: [DSRadioBtnGroupItem]) {
        self.componentId = componentId
        self.items = items
    }
}

public struct DSRadioBtnGroupItem: Codable {
    public let radioBtnGroupOrg: DSRadioBtnGroupOrg
    
    public init(radioBtnGroupOrg: DSRadioBtnGroupOrg) {
        self.radioBtnGroupOrg = radioBtnGroupOrg
    }
}
        
