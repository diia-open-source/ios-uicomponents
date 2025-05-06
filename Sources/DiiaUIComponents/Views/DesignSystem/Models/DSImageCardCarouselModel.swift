
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
