
import Foundation

public struct DSCollapsibleTitleMlcModel: Codable, Equatable {
    public let componentId: String
    public let title: String?
    public let expanded: DSCollapsibleTitleMlcExpanded?

    public init(componentId: String, title: String? = nil, expanded: DSCollapsibleTitleMlcExpanded? = nil) {
        self.componentId = componentId
        self.title = title
        self.expanded = expanded
    }

    static let mock = DSCollapsibleTitleMlcModel(
        componentId: "componentId",
        title: "title",
        expanded: DSCollapsibleTitleMlcExpanded(
            expandedText: "expandedText",
            collapsedText: "collapsedText",
            isExpanded: false
        )
    )
}

public struct DSCollapsibleTitleMlcExpanded: Codable, Equatable {
    public let expandedText: String
    public let collapsedText: String
    public let isExpanded: Bool?

    public init(expandedText: String, collapsedText: String, isExpanded: Bool? = nil) {
        self.expandedText = expandedText
        self.collapsedText = collapsedText
        self.isExpanded = isExpanded
    }
}
