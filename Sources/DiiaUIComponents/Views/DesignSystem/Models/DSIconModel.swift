
import Foundation

/// design_system_code:  smallIconAtm
public struct DSIconModel: Codable, Equatable {
    public let code: String
    public let accessibilityDescription: String?
    public let action: DSActionParameter?
    public let componentId: String?
    public let isEnable: Bool?
    
    public init(code: String,
                accessibilityDescription: String? = nil,
                componentId: String? = nil,
                action: DSActionParameter? = nil,
                isEnable: Bool = true) {
        self.code = code
        self.accessibilityDescription = accessibilityDescription
        self.componentId = componentId
        self.action = action
        self.isEnable = isEnable
    }
    
    static let mock = DSIconModel(
        code: "mockCode",
        accessibilityDescription: "accessibilityDescription(optional)",
        componentId: "componentId(optional)",
        action: .mock,
        isEnable: true
    )
}
