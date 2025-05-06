
import Foundation

/// design_system_code: inputTextMultilineMlc
public struct DSInputTextMultilineMlc: Codable {
    public let componentId: String?
    public let inputCode: String?
    public let label: String
    public let placeholder: String?
    public let hint: String?
    public let value: String?
    public let mandatory: Bool?
    public let validation: [InputValidationModel]?
    
    public init(componentId: String?, inputCode: String?, label: String, placeholder: String?, hint: String?, value: String?, mandatory: Bool?, validation: [InputValidationModel]?) {
        self.componentId = componentId
        self.inputCode = inputCode
        self.label = label
        self.placeholder = placeholder
        self.hint = hint
        self.value = value
        self.mandatory = mandatory
        self.validation = validation
    }
}
