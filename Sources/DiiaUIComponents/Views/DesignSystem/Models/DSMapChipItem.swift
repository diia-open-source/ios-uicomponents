

// MARK: - DSMapChipItemView
public struct DSMapChipItem {
    public let componentId: String?
    public let accessibilityDescription: String?
    public let code: String
    public let label: String?
    public let icon: String?
    public var isSelected: Bool
    
    public init(code: String,
                label: String?,
                icon: String?,
                componentId: String?,
                accessibilityDescription: String?,
                isSelected: Bool) {
        self.code = code
        self.label = label
        self.icon = icon
        self.componentId = componentId
        self.accessibilityDescription = accessibilityDescription
        self.isSelected = isSelected
    }
}
