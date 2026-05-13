
/// ds_code: btnIconPlainStrokeMlc
public struct DSBtnIconPlainStrokeMlcModel: Codable {
    public let componentId: String
    public let label: String
    public let state: DSButtonState?
    public let iconLeft: DSIconModel
    public let action: DSActionParameter?

    public init(componentId: String,
                label: String,
                state: DSButtonState?,
                iconLeft: DSIconModel,
                action: DSActionParameter?) {
        self.componentId = componentId
        self.label = label
        self.state = state
        self.iconLeft = iconLeft
        self.action = action
    }

    static let mock = DSBtnIconPlainStrokeMlcModel(
        componentId: "componentId",
        label: "label",
        state: .enabled,
        iconLeft: .mock,
        action: .mock
    )
}
