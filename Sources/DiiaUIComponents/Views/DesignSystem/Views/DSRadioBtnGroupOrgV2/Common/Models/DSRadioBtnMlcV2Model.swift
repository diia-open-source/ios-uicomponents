
import DiiaCommonTypes

public struct DSRadioBtnMlcV2Model: Codable {
    public let componentId: String
    public let id: String?
    public let iconLeft: DSIconModel?
    public let iconRight: DSIconModel?
    public let iconBigRight: DSIconModel?
    public let label: String
    public let description: String?
    public let status: String?
    public let isSelected: Bool?
    public let isEnabled: Bool?
    public let dataJson: AnyCodable?
    
    public init(componentId: String, id: String?, iconLeft: DSIconModel?, iconRight: DSIconModel?, iconBigRight: DSIconModel?, label: String, description: String?, status: String?, isSelected: Bool?, isEnabled: Bool?, dataJson: AnyCodable?) {
        self.componentId = componentId
        self.id = id
        self.iconLeft = iconLeft
        self.iconRight = iconRight
        self.iconBigRight = iconBigRight
        self.label = label
        self.description = description
        self.status = status
        self.isSelected = isSelected
        self.isEnabled = isEnabled
        self.dataJson = dataJson
    }
    
}

public struct DSRadioGroupItemV2: Codable {
    public let radioBtnMlcV2: DSRadioBtnMlcV2Model?
    
    public init(radioBtnMlcV2: DSRadioBtnMlcV2Model) {
        self.radioBtnMlcV2 = radioBtnMlcV2
    }
}
