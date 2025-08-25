
public struct PhotoCardMlc: Codable {
    public let componentId: String
    public let accessibilityDescription: String?
    public let iconRight: DSIconModel?
    public let photo: String // String URL
    public let tableItemCheckboxMlc: DSTableItemCheckboxModel?
    public let radioBtnMlcV2: DSTableItemCheckboxModel?
    public let action: DSActionParameter?
 
    public init(componentId: String,
                iconRight: DSIconModel?,
                photo: String,
                tableItemCheckboxMlc: DSTableItemCheckboxModel?,
                radioBtnMlcV2: DSTableItemCheckboxModel?,
                action: DSActionParameter?,
                accessibilityDescription: String? = nil) {
        self.componentId = componentId
        self.iconRight = iconRight
        self.photo = photo
        self.tableItemCheckboxMlc = tableItemCheckboxMlc
        self.radioBtnMlcV2 = radioBtnMlcV2
        self.action = action
        self.accessibilityDescription = accessibilityDescription
    }
}
