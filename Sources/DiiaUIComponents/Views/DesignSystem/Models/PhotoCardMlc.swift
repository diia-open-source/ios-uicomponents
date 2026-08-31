
public struct PhotoCardMlc: Codable {
    public let componentId: String
    public let accessibilityDescription: String?
    public let id: String?
    public let iconRight: DSIconModel?
    public let photo: String // String URL
    public let checkBoxMlc: DSCheckboxMlcModel?
    public let radioBtnElementMlc: DSRadioBtnElementMlcModel?
    public let action: DSActionParameter?
 
    public init(componentId: String,
                iconRight: DSIconModel?,
                id: String?,
                photo: String,
                checkBoxMlc: DSCheckboxMlcModel?,
                radioBtnElementMlc: DSRadioBtnElementMlcModel?,
                action: DSActionParameter?,
                accessibilityDescription: String? = nil) {
        self.componentId = componentId
        self.iconRight = iconRight
        self.id = id
        self.photo = photo
        self.checkBoxMlc = checkBoxMlc
        self.radioBtnElementMlc = radioBtnElementMlc
        self.action = action
        self.accessibilityDescription = accessibilityDescription
    }
}
