
import Foundation
import DiiaCommonTypes

public struct DSAttentionIconMessageMlc: Codable, Equatable {
    public let componentId: String?
    public let smallIconAtm: DSIconModel
    public let text: String
    public let parameters: [TextParameter]?
    public let backgroundMode: DSAttentionIconBackgroundMode
    public let expanded: DSAttentionIconMessageMlcExpanded?
    public let btnStrokeAdditionalAtm: DSButtonModel?
    
    public init(
        componentId: String?,
        smallIconAtm: DSIconModel,
        text: String,
        parameters: [TextParameter]?,
        backgroundMode: DSAttentionIconBackgroundMode,
        expanded: DSAttentionIconMessageMlcExpanded?,
        btnStrokeAdditionalAtm: DSButtonModel? = nil
    ) {
        self.componentId = componentId
        self.smallIconAtm = smallIconAtm
        self.text = text
        self.parameters = parameters
        self.backgroundMode = backgroundMode
        self.expanded = expanded
        self.btnStrokeAdditionalAtm = btnStrokeAdditionalAtm
    }
    
    static let mock = DSAttentionIconMessageMlc(
        componentId: "componentId",
        smallIconAtm: .mock,
        text: "text",
        parameters: [
            TextParameter(
                type: .link,
                data: TextParameterData(name: "name", alt: "alt", resource: "resource")
            )
        ],
        backgroundMode: .info,
        expanded: DSAttentionIconMessageMlcExpanded(
            expandedText: "expandedText",
            collapsedText: "collapsedText",
            isExpanded: true
        ),
        btnStrokeAdditionalAtm: .mock
    )
}

public struct DSAttentionIconMessageMlcExpanded: Codable, Equatable {
    public let expandedText: String
    public let collapsedText: String
    public let isExpanded: Bool?
    
    public init(expandedText: String, collapsedText: String, isExpanded: Bool?) {
        self.expandedText = expandedText
        self.collapsedText = collapsedText
        self.isExpanded = isExpanded
    }
}

public enum DSAttentionIconBackgroundMode: String, Codable, Equatable {
    case info
    case note
    
    public var color: String {
        switch self {
        case .info: "#FAF7BA"
        case .note: "#0075FB29"
        }
    }
}
