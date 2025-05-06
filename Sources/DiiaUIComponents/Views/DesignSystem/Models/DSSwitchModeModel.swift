
import Foundation

public struct DSSwitchModeModel: Codable {
    public let componentId: String?
    public let primaryIconAtm: DSIconModel
    public let secondaryIconAtm: DSIconModel
    public let selectedId: String?
    
    public init(
        componentId: String?,
        primaryIconAtm: DSIconModel,
        secondaryIconAtm: DSIconModel,
        selectedId: String? = nil
    ) {
        self.componentId = componentId
        self.primaryIconAtm = primaryIconAtm
        self.secondaryIconAtm = secondaryIconAtm
        self.selectedId = selectedId
    }
}
