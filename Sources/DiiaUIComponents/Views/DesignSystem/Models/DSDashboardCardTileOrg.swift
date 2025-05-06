
import Foundation

public struct DSDashboardCardTileOrg: Codable {
    public let componentId: String
    public let items: [DSDashboardCardItem]
    
    public init(componentId: String, items: [DSDashboardCardItem]) {
        self.componentId = componentId
        self.items = items
    }
}

public struct DSDashboardCardItem: Codable {
    public let dashboardCardMlc: DSDashboardCardMlc?
    
    public init(dashboardCardMlc: DSDashboardCardMlc?) {
        self.dashboardCardMlc = dashboardCardMlc
    }
}
