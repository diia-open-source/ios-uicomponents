
import Foundation

/// design_system_code: calendarOrg
/// 
public struct DSCalendarItemOrg: Codable {
    public let componentId: String?
    public let date: String
    public let calendarItemAtm: DSCalendarItemAtm?
    public let chipGroupOrg: DSChipGroupOrg?
    
    public init(componentId: String? = nil, date: String, calendarItemAtm: DSCalendarItemAtm?, chipGroupOrg: DSChipGroupOrg? = nil) {
        self.componentId = componentId
        self.date = date
        self.calendarItemAtm = calendarItemAtm
        self.chipGroupOrg = chipGroupOrg
    }
}
