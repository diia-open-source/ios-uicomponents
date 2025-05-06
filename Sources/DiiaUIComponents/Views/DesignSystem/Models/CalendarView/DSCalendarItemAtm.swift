
import Foundation

/// design_system_code: calendarItemAtm

public struct DSCalendarItemAtm: Codable {
    public let label: String
    public let isActive: Bool?
    public let isToday: Bool?
    public let isSelected: Bool?
    
    public init(label: String, isActive: Bool? = false, isToday: Bool? = false, isSelected: Bool? = false) {
        self.label = label
        self.isActive = isActive
        self.isToday = isToday
        self.isSelected = isSelected
    }
}
