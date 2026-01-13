
import Foundation

/// design_system_code: calendarOrgV2

public struct DSCalendarOrgV2: Codable {
    public let componentId: String?
    public let inputCode: String?
    public let mandatory: Bool?
    public let currentTimeMlc: DSCurrentTimeMlc?
    public let legends: [DSLegendGroup]?
    public let iconForMovingForward: DSIconModel?
    public let iconForMovingBackwards: DSIconModel?
    public let columnsAmount: Int?
    public let items: [DSCalendarItem]
    public let paginationMessageMlc: DSPaginationMessageMlcModel?
    
    public init(
        componentId: String?,
        inputCode: String?,
        mandatory: Bool?,
        currentTimeMlc: DSCurrentTimeMlc?,
        legends: [DSLegendGroup]?,
        iconForMovingForward: DSIconModel?,
        iconForMovingBackwards: DSIconModel?,
        columnsAmount: Int?,
        items: [DSCalendarItem],
        paginationMessageMlc: DSPaginationMessageMlcModel?) {
            self.componentId = componentId
            self.inputCode = inputCode
            self.mandatory = mandatory
            self.currentTimeMlc = currentTimeMlc
            self.legends = legends
            self.iconForMovingForward = iconForMovingForward
            self.iconForMovingBackwards = iconForMovingBackwards
            self.columnsAmount = columnsAmount
            self.items = items
            self.paginationMessageMlc = paginationMessageMlc
        }
}
