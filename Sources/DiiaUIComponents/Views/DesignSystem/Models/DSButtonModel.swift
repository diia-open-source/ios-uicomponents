
import Foundation
import DiiaCommonTypes

public struct DSButtonModel: Codable {
    public let label: String
    public let state: DSButtonState?
    public let action: DSActionParameter?
    public let componentId: String?
    
    public init(label: String,
                state: DSButtonState? = nil,
                action: DSActionParameter? = nil,
                componentId: String? = nil) {
        self.label = label
        self.state = state
        self.action = action
        self.componentId = componentId
    }
}

public enum DSButtonState: String, Codable, EnumDecodable {
    public static var defaultValue: DSButtonState = .disabled
    
    case enabled
    case disabled
    case invisible
    case selected
}
