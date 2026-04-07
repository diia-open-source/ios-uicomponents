
import DiiaCommonTypes

public struct DSImageCardCarouselModel: Codable {
    public let componentId: String
    public let dotNavigationAtm: DSDotNavigationModel
    public let items: [AnyCodable]
    
    public init(componentId: String, dotNavigationAtm: DSDotNavigationModel, items: [AnyCodable]) {
        self.componentId = componentId
        self.dotNavigationAtm = dotNavigationAtm
        self.items = items
    }
}

public struct DSCardImageCarouselModel: Codable {
    public let componentId: String
    public let dotBlackNavigationAtm: DSBlackDotNavigationModel
    public let items: [AnyCodable]
    
    public init(componentId: String, dotBlackNavigationAtm: DSBlackDotNavigationModel, items: [AnyCodable]) {
        self.componentId = componentId
        self.dotBlackNavigationAtm = dotBlackNavigationAtm
        self.items = items
    }
}
