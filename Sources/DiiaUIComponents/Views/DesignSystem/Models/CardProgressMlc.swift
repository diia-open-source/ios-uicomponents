
public struct CardProgressMlc: Codable {
    public let componentId: String
    public let label: String?
    public let rightLabel: String?
    public let description: String?
    public let chipStatusAtm: DSCardStatusChipModel?
    public let leftBigImage: DSIconUrlAtmModel?
    public let iconRight: DSIconModel?
    public let progressBarAtm: ProgressBarAtm
    public let action: DSActionParameter?
    
    public init(componentId: String, label: String? = nil, rightLabel: String? = nil, description: String? = nil, chipStatusAtm: DSCardStatusChipModel? = nil, leftBigImage: DSIconUrlAtmModel? = nil, iconRight: DSIconModel? = nil, progressBarAtm: ProgressBarAtm, action: DSActionParameter? = nil) {
        self.componentId = componentId
        self.label = label
        self.rightLabel = rightLabel
        self.description = description
        self.chipStatusAtm = chipStatusAtm
        self.leftBigImage = leftBigImage
        self.iconRight = iconRight
        self.progressBarAtm = progressBarAtm
        self.action = action
    }
}

public struct ProgressBarAtm: Codable {
    public let componentId: String
    public let percent: Float
    public let percentText: String
    
    public init(componentId: String, percent: Float, percentText: String) {
        self.componentId = componentId
        self.percent = percent
        self.percentText = percentText
    }
}
