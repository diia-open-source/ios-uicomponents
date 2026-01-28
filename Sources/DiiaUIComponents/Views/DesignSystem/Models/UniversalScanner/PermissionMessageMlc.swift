
public struct PermissionMessageMlc: Codable {
    public let componentId: String
    public let title: String
    public let description: String
    public let btnPrimaryDefaultAtm: DSButtonModel?
    
    public init(
        componentId: String,
        title: String,
        description: String,
        btnPrimaryDefaultAtm: DSButtonModel?
    ) {
        self.componentId = componentId
        self.title = title
        self.description = description
        self.btnPrimaryDefaultAtm = btnPrimaryDefaultAtm
    }
}
