
import Foundation

/// design_system_code: inputNumberMlc
public struct DSInputNumberMlc: Codable {
    public let componentId: String?
    public let inputCode: String?
    public let label: String
    public let placeholder: String?
    public let hint: String?
    public let value: Double?
    public let maxValue: Double?
    public let minValue: Double?
    public let mandatory: Bool?
    public let errorMessage: String?
    public let mask: String?
    public let iconRight: DSIconModel?
    public let decimalCount: Int?
    public let minIntegerCount: Int?
    public let autoFillDecimal: Bool?
    
    public init(
        componentId: String?,
        inputCode: String?,
        label: String,
        placeholder: String?,
        hint: String?,
        value: Double?,
        maxValue: Double?,
        minValue: Double?,
        mandatory: Bool?,
        errorMessage: String?,
        mask: String? = nil,
        iconRight: DSIconModel? = nil,
        decimalCount: Int? = nil,
        minIntegerCount: Int? = nil,
        autoFillDecimal: Bool? = false
    ) {
        self.componentId = componentId
        self.inputCode = inputCode
        self.label = label
        self.placeholder = placeholder
        self.hint = hint
        self.value = value
        self.maxValue = maxValue
        self.minValue = minValue
        self.mandatory = mandatory
        self.errorMessage = errorMessage
        self.mask = mask
        self.iconRight = iconRight
        self.decimalCount = decimalCount
        self.minIntegerCount = minIntegerCount
        self.autoFillDecimal = autoFillDecimal
    }
}

