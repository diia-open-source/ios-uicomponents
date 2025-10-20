
import DiiaCommonTypes

public struct DSSearchScreenDataModel: Codable {
    public let searchScreenTitle: String?
    public let searchPlaceholder: String
    public let items: [DSListWidgetItemsContainer]
    public let paginationMessageMlc: DSPaginationMessageMlcModel
}

public struct DSSelectorOrgV2Model: Codable {
    public let componentId: String?
    public let inputCode: String?
    public let mandatory: Bool?
    public let label: String
    public let placeholder: String
    public let hint: String?
    public let valueId: String?
    public let value: String?
    public let isEnabled: Bool?
    public let searchScreenData: DSSearchScreenDataModel?
    public let action: DSActionParameter?
}
