
import Foundation

/// design_system_code: inputTextMlc
public struct DSInputTextMlc: Codable {
    public let id: String?
    public let blocker: Bool?
    public let label: String
    public let placeholder: String?
    public let hint: String?
    public let value: String?
    public let mandatory: Bool?
    public let validation: [InputValidationModel]?
    public let inputCode: String?
    public let keyboardType: Int?
    
    public init(id: String?, blocker: Bool?, label: String, placeholder: String?, hint: String?, value: String?, mandatory: Bool?, validation: [InputValidationModel]?, inputCode: String?, keyboardType: Int? = nil) {
        self.id = id
        self.blocker = blocker
        self.label = label
        self.placeholder = placeholder
        self.hint = hint
        self.value = value
        self.mandatory = mandatory
        self.validation = validation
        self.inputCode = inputCode
        self.keyboardType = keyboardType
    }
}
