
import Foundation

/// design_system_code: currentTimeMlc

public struct DSCurrentTimeMlc: Codable {
    public let componentId: String?
    public let label: String
    public let maxDate: String?
    public let minDate: String?
    public let displayMonth: String?
    public let action: DSActionParameter?
    
    public init(
        componentId: String? = nil,
        label: String,
        maxDate: String? = nil,
        minDate: String? = nil,
        displayMonth: String? = nil,
        action: DSActionParameter? = nil) {
            self.componentId = componentId
            self.label = label
            self.maxDate = maxDate
            self.minDate = minDate
            self.displayMonth = displayMonth
            self.action = action
        }
}
