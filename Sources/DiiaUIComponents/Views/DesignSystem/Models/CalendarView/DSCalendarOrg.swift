
import Foundation

/// design_system_code: calendarOrg

public struct DSCalendarOrg: Codable {
    public let componentId: String?
    public let inputCode: String?
    public let mandatory: Bool?
    public let currentTimeMlc: DSCurrentTimeMlc?
    public let iconForMovingForward: DSMovingIcon?
    public let iconForMovingBackwards: DSMovingIcon?
    public let columnsAmount: Int?
    public let items: [DSCalendarItem]
    public let stubMessageMlc: DSStubMessageMlc?
    
    public init(componentId: String?,
                inputCode: String?,
                mandatory: Bool?,
                currentTimeMlc: DSCurrentTimeMlc?,
                iconForMovingForward: DSMovingIcon?,
                iconForMovingBackwards: DSMovingIcon?,
                columnsAmount: Int?,
                items: [DSCalendarItem],
                stubMessageMlc: DSStubMessageMlc? = nil) {
        self.componentId = componentId
        self.inputCode = inputCode
        self.mandatory = mandatory
        self.currentTimeMlc = currentTimeMlc
        self.iconForMovingForward = iconForMovingForward
        self.iconForMovingBackwards = iconForMovingBackwards
        self.columnsAmount = columnsAmount
        self.items = items
        self.stubMessageMlc = stubMessageMlc
    }
}

public struct DSCalendarItem: Codable {
    public let calendarItemOrg: DSCalendarItemOrg
    
    public init(calendarItemOrg: DSCalendarItemOrg) {
        self.calendarItemOrg = calendarItemOrg
    }
}

public struct DSMovingIcon: Codable {
    public let iconAtm: DSIconModel
    
    public init(iconAtm: DSIconModel) {
        self.iconAtm = iconAtm
    }
}
