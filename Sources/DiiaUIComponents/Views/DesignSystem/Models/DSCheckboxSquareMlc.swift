
import Foundation

public struct DSCheckboxSquareMlc: Codable {
    public let id: String?
    public let label: String
    public let isSelected: Bool?
    public let isEnabled: Bool?
    public let componentId: String?
    public let blocker: Bool?
    public let options: [DSCheckboxOption]?
    
    public init(id: String? = nil,
                label: String,
                isSelected: Bool? = nil,
                isEnabled: Bool? = nil,
                componentId: String? = nil,
                blocker: Bool? = nil,
                options: [DSCheckboxOption]? = nil) {
        self.id = id
        self.label = label
        self.isSelected = isSelected
        self.isEnabled = isEnabled
        self.componentId = componentId
        self.blocker = blocker
        self.options = options
    }
}

public struct DSCheckboxOption: Codable {
    public let id: String?
    public let isSelected: Bool
}
