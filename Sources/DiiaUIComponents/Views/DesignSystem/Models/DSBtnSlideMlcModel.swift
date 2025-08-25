
import Foundation

/// design_system_code:  btnSlideMlc
public struct DSBtnSlideMlcModel: Codable {
    public let componentId: String?
    public let label: String
    public let icon: DSIconModel?
    public let state: DSBtnSlideMlcState?
    public let action: DSActionParameter?

    public init(componentId: String? = nil, label: String, icon: DSIconModel? = nil, state: DSBtnSlideMlcState? = nil, action: DSActionParameter? = nil) {
        self.componentId = componentId
        self.label = label
        self.icon = icon
        self.state = state
        self.action = action
    }
}

public enum DSBtnSlideMlcState: String, Codable, Equatable {
    case enabled
    case disabled
}
