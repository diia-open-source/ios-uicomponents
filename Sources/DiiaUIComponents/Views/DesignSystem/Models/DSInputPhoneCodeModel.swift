
import Foundation

public struct DSInputPhoneCodeModel: Codable {
    public let componentId: String?
    public let label: String
    public let hint: String?
    public let mandatory: Bool?
    public let inputCode: String
    public let inputPhoneMlc: DSInputPhoneModel
    public let codeValueId: String?
    public let codeValueIsEditable: Bool?
    public let codes: [DSPhoneCodeModel]
    
    public init(
        componentId: String?,
        label: String,
        hint: String?,
        mandatory: Bool?,
        inputCode: String,
        inputPhoneMlc: DSInputPhoneModel,
        codeValueId: String?,
        codeValueIsEditable: Bool?,
        codes: [DSPhoneCodeModel]
    ) {
        self.componentId = componentId
        self.label = label
        self.hint = hint
        self.mandatory = mandatory
        self.inputCode = inputCode
        self.inputPhoneMlc = inputPhoneMlc
        self.codeValueId = codeValueId
        self.codeValueIsEditable = codeValueIsEditable
        self.codes = codes
    }
}

public struct DSInputPhoneModel: Codable {
    public let componentId: String
    public let inputCode: String?
    public let label: String?
    public let placeholder: String?
    public let hint: String?
    public let mask: String?
    public let value: String?
    public let mandatory: Bool?
    public let validation: [InputValidationModel]?
    
    public init(
        componentId: String,
        inputCode: String?,
        label: String?,
        placeholder: String?,
        hint: String?,
        mask: String?,
        value: String?,
        mandatory: Bool?,
        validation: [InputValidationModel]?
    ) {
        self.componentId = componentId
        self.inputCode = inputCode
        self.label = label
        self.placeholder = placeholder
        self.hint = hint
        self.mask = mask
        self.value = value
        self.mandatory = mandatory
        self.validation = validation
    }
}

public struct DSPhoneCodeModel: Codable {
    public let id: String
    public let maskCode: String?
    public let placeholder: String?
    public let label: String
    public let description: String
    public var value: String
    public let icon: String
    public let validation: [InputValidationModel]?
    
    public init(
        id: String,
        maskCode: String?,
        placeholder: String?,
        label: String,
        description: String,
        value: String,
        icon: String,
        validation: [InputValidationModel]?
    ) {
        self.id = id
        self.maskCode = maskCode
        self.placeholder = placeholder
        self.label = label
        self.description = description
        self.value = value
        self.icon = icon
        self.validation = validation
    }
}
