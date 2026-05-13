
import DiiaCommonTypes

public struct StateMessageMlcModel: Codable {
    public let componentId: String
    public let iconAtm: DSIconModel?
    public let title: String?
    public let description: String?
    public let btnStrokeAdditionalAtm: DSButtonModel?
}
