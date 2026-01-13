
import Foundation

/// design_system_code: calendarItemOrg
///
public struct DSCalendarItemOrg: Codable {
    public let componentId: String?
    public let date: String
    public let calendarItemAtm: DSCalendarItemAtm?
    public let chipGroupOrg: DSChipGroupOrg?
    public let chipGroupOrgV2: DSChipGroupOrgV2?
    public let legendType: DSLegendType?
    
    public init(componentId: String? = nil,
                date: String,
                calendarItemAtm: DSCalendarItemAtm?,
                chipGroupOrg: DSChipGroupOrg? = nil,
                chipGroupOrgV2: DSChipGroupOrgV2? = nil,
                legendType: DSLegendType? = nil) {
        self.componentId = componentId
        self.date = date
        self.calendarItemAtm = calendarItemAtm
        self.chipGroupOrg = chipGroupOrg
        self.chipGroupOrgV2 = chipGroupOrgV2
        self.legendType = legendType
    }
}
