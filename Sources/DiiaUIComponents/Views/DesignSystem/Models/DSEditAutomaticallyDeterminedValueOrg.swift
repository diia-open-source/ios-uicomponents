
import Foundation

/// design_system_code: editAutomaticallyDeterminedValueOrg
public struct DSEditAutomaticallyDeterminedValueOrg: Codable {
    public let title: String?
    public let label: String?
    public let value: String?
    public let inputTextMultilineMlc: DSInputTextMultilineMlc
    public let componentId: String?
    
    public init(title: String? = nil,
                label: String? = nil,
                value: String? = nil,
                inputTextMultilineMlc: DSInputTextMultilineMlc,
                componentId: String? = nil) {
        self.title = title
        self.label = label
        self.value = value
        self.inputTextMultilineMlc = inputTextMultilineMlc
        self.componentId = componentId
    }
}
