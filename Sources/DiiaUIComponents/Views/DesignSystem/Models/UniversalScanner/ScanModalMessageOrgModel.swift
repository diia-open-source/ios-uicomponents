
import Foundation

public struct ScanModalMessageOrgModel: Codable {
    public let componentId: String
    public let title: String
    public let description: String?
    public let iconCentre: DSIconModel?
    public let btnPrimaryDefaultAtm: DSButtonModel?
    public let mediumIconAtm: DSIconModel?
    
    public init(
        componentId: String,
        title: String,
        description: String?,
        iconCentre: DSIconModel?,
        btnPrimaryDefaultAtm: DSButtonModel?,
        mediumIconAtm: DSIconModel?
    ) {
        self.componentId = componentId
        self.title = title
        self.description = description
        self.iconCentre = iconCentre
        self.btnPrimaryDefaultAtm = btnPrimaryDefaultAtm
        self.mediumIconAtm = mediumIconAtm
    }
}
