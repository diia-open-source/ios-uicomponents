
import DiiaCommonTypes

/// design_system_code: dotChipStatusMlc
public struct DSDotChipStatusMlcModel: Codable, Equatable {
    public let componentId: String
    public let label: String
    public let type: DSCardStatusChipType
    public let isVisible: Bool

    public init(componentId: String,
                label: String,
                type: DSCardStatusChipType,
                isVisible: Bool) {
        self.componentId = componentId
        self.label = label
        self.type = type
        self.isVisible = isVisible
    }

    static let mock = DSDotChipStatusMlcModel(
        componentId: "componentId",
        label: "label",
        type: .success,
        isVisible: true
    )
}
