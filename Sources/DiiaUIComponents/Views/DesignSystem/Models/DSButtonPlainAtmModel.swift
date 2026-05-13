
public struct DSButtonPlainAtmModel: Codable, Equatable {
    public let componentId: String?
    public let label: String
    public let iconLeft: DSIconModel?
    public let state: DSButtonState?
    public let action: DSActionParameter?

    public init(componentId: String? = nil,
                label: String,
                iconLeft: DSIconModel? = nil,
                state: DSButtonState? = nil,
                action: DSActionParameter? = nil) {
        self.componentId = componentId
        self.label = label
        self.iconLeft = iconLeft
        self.state = state
        self.action = action
    }

    static let mock = DSButtonPlainAtmModel(
        componentId: "componentId(optional)",
        label: "mockLabel mockLabel mockLabel mockLabel",
        iconLeft: .mock,
        state: .enabled,
        action: .mock)
}
