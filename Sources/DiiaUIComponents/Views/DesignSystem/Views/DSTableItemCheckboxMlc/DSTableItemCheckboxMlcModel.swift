
import UIKit
import DiiaCommonTypes

public struct DSTableItemCheckboxModel: Codable {
    public let componentId: String?
    public let inputCode: String?
    public let mandatory: Bool?
    public let rows: [DSTableItemCheckboxRowModel]
    public let isSelected: Bool?
    public let isEnabled: Bool?
    public let isNotFullSelected: Bool?
    public let dataJson: String?
    
    public init(
        componentId: String?,
        inputCode: String?,
        mandatory: Bool?,
        rows: [DSTableItemCheckboxRowModel],
        isSelected: Bool? = false,
        isNotFullSelected: Bool?,
        dataJson: String?,
        isEnabled: Bool? = true
    ) {
        self.componentId = componentId
        self.inputCode = inputCode
        self.mandatory = mandatory
        self.rows = rows
        self.isSelected = isSelected
        self.isEnabled = isEnabled
        self.isNotFullSelected = isNotFullSelected
        self.dataJson = dataJson
    }
}

public struct DSTableItemCheckboxRowModel: Codable {
    public let textLabelAtm: DSTextLabelAtmModel
    
    public init(textLabelAtm: DSTextLabelAtmModel) {
        self.textLabelAtm = textLabelAtm
    }
}

public struct DSTextLabelAtmModel: Codable {
    public let componentId: String?
    public let mode: DSTextLabelAtmMode
    public let label: String
    public let value: String?
    
    public init(
        componentId: String? = nil,
        mode: DSTextLabelAtmMode,
        label: String,
        value: String?
    ) {
        self.componentId = componentId
        self.mode = mode
        self.label = label
        self.value = value
    }
}

public enum DSTextLabelAtmMode: String, Codable, EnumDecodable {
    public static var defaultValue: DSTextLabelAtmMode = .primary
    
    case primary
    case secondary
    
    var textColor: UIColor {
        self == .primary ? .black : .black.withAlphaComponent(0.4)
    }
}
