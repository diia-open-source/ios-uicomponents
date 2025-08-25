
import DiiaCommonTypes

public struct DSAccordionOrgExpandedContentModel: Codable {
    public let items: [AnyCodable]
}

public struct DSAccordionOrgModel: Codable {
    public let componentId: String?
    public let heading: String
    public let description: String?
    public let states: DSAccordionOrgState
    public let expandedContent: DSAccordionOrgExpandedContentModel?
}

public struct DSAccordionOrgState: Codable {
    public let isExpanded: Bool?
    public let expandedIcon: DSIconModel?
    public let collapsedIcon: DSIconModel?
}
