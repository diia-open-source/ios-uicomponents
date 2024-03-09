import Foundation

public struct DSIconModel: Codable {
    public let code: String
    public let accessibilityDescription: String?
    public let action: DSActionParameter?
    
    public init(code: String,
                accessibilityDescription: String? = nil,
                action: DSActionParameter? = nil) {
        self.code = code
        self.accessibilityDescription = accessibilityDescription
        self.action = action
    }
}
