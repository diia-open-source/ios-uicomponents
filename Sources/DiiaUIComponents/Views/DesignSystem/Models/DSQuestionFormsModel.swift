
import Foundation
import DiiaCommonTypes

public struct DSQuestionFormsModel: Codable {
    public let componentId: String?
    public let id: String
    public let title: String?
    public let condition: String?
    public let items: [AnyCodable]
    
    public init(componentId: String?, id: String, title: String?, condition: String?, items: [AnyCodable]) {
        self.componentId = componentId
        self.id = id
        self.title = title
        self.condition = condition
        self.items = items
    }
}

public struct DSQuestionFormsItem: Codable {
    public let inputTextMlc: DSInputTextMlc?
    public let inputDateMlc: DSInputDateModel?
    public let selectorOrg: DSSelectorModel?
    public let checkboxSquareMlc: DSCheckboxSquareModel?
    public let inputPhoneCodeOrg: DSInputPhoneCodeModel?
    
    public init(inputTextMlc: DSInputTextMlc? = nil,
                inputDateMlc: DSInputDateModel? = nil,
                selectorOrg: DSSelectorModel? = nil,
                checkboxSquareMlc: DSCheckboxSquareModel? = nil,
                inputPhoneCodeOrg: DSInputPhoneCodeModel? = nil) {
        self.inputTextMlc = inputTextMlc
        self.inputDateMlc = inputDateMlc
        self.selectorOrg = selectorOrg
        self.checkboxSquareMlc = checkboxSquareMlc
        self.inputPhoneCodeOrg = inputPhoneCodeOrg
    }
}

public struct DSInputDateModel: Codable {
    public let componentId: String?
    public let id: String?
    public let inputCode: String?
    public let blocker: Bool?
    public let mandatory: Bool?
    public let label: String
    public let value: String?
    public let hint: String?
    public let validation: [InputValidationModel]?
    
    public init(componentId: String?, id: String?, inputCode: String?, blocker: Bool?, mandatory: Bool? = nil, label: String, value: String?, hint: String?, validation: [InputValidationModel]?) {
        self.componentId = componentId
        self.id = id
        self.inputCode = inputCode
        self.blocker = blocker
        self.label = label
        self.value = value
        self.hint = hint
        self.mandatory = mandatory
        self.validation = validation
    }
}

public struct DSCheckboxSquareModel: Codable {
    public let id: String?
    public let blocker: Bool?
    public let label: String
    public let options: [DSCheckboxSquareModelOption]
    public let isSelected: Bool?
    public let isEnabled: Bool?
    
    public init(id: String?, blocker: Bool?, label: String, options: [DSCheckboxSquareModelOption], isSelected: Bool?, isEnabled: Bool?) {
        self.id = id
        self.blocker = blocker
        self.label = label
        self.options = options
        self.isSelected = isSelected
        self.isEnabled = isEnabled
    }
}

public struct DSCheckboxSquareModelOption: Codable {
    public let id: String
    public let isSelected: Bool
    
    public init(id: String, isSelected: Bool) {
        self.id = id
        self.isSelected = isSelected
    }
}
