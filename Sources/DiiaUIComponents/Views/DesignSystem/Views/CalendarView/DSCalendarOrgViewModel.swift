
import Foundation
import DiiaCommonTypes

public final class DSCalendarOrgViewModel {
    
    public var inputCode: String?
    
    public let calendarOrg: Observable<DSCalendarModel>
    
    public let isLoading = Observable<Bool>(value: false)
    public let selectedPeriod = Observable<Date?>(value: nil)
    public let selectedDate = Observable<Date?>(value: nil)
    public let selectedChipData = Observable<AnyCodable?>(value: nil)
    
    public let stubMessage = Observable<DSStubMessageMlc?>(value: nil)
    public let paginationMessage = Observable<DSPaginationMessageMlcModel?>(value: nil)
    
    public let isOldVersion: Bool
    public let legends: [DSLegendGroupMlc]?
    public var eventHandler: ((ConstructorItemEvent) -> ())?
    
    public init(calendarOrg: DSCalendarOrg,
                inputCode: String? = nil) {
        self.calendarOrg = .init(value: DSCalendarModel(
            currentTimeMlc: calendarOrg.currentTimeMlc,
            iconForMovingForward: calendarOrg.iconForMovingForward?.iconAtm,
            iconForMovingBackwards: calendarOrg.iconForMovingBackwards?.iconAtm,
            items: calendarOrg.items))
        self.stubMessage.value = calendarOrg.stubMessageMlc
        if let code = inputCode {
            self.inputCode = code
        }
        self.isOldVersion = true
        self.legends = nil
    }
    
    public init(calendarOrg: DSCalendarOrgV2,
                inputCode: String? = nil) {
        self.calendarOrg = .init(value: DSCalendarModel(
            currentTimeMlc: calendarOrg.currentTimeMlc,
            iconForMovingForward: calendarOrg.iconForMovingForward,
            iconForMovingBackwards: calendarOrg.iconForMovingBackwards,
            items: calendarOrg.items))
        self.legends = calendarOrg.legends?.map({$0.legendGroupMlc})
        self.paginationMessage.value = calendarOrg.paginationMessageMlc
        self.isOldVersion = false
        if let code = inputCode {
            self.inputCode = code
        }
    }
}

public struct DSCalendarModel {
    public let currentTimeMlc: DSCurrentTimeMlc?
    public let iconForMovingForward: DSIconModel?
    public let iconForMovingBackwards: DSIconModel?
    public let items: [DSCalendarItem]
    
    init(currentTimeMlc: DSCurrentTimeMlc?, iconForMovingForward: DSIconModel?, iconForMovingBackwards: DSIconModel?, items: [DSCalendarItem]) {
        self.currentTimeMlc = currentTimeMlc
        self.iconForMovingForward = iconForMovingForward
        self.iconForMovingBackwards = iconForMovingBackwards
        self.items = items
    }
    
    public init(calendarOrg: DSCalendarOrg) {
        self.currentTimeMlc = calendarOrg.currentTimeMlc
        self.iconForMovingForward = calendarOrg.iconForMovingForward?.iconAtm
        self.iconForMovingBackwards = calendarOrg.iconForMovingBackwards?.iconAtm
        self.items = calendarOrg.items
    }
    
    public init(calendarOrg: DSCalendarOrgV2) {
        self.currentTimeMlc = calendarOrg.currentTimeMlc
        self.iconForMovingForward = calendarOrg.iconForMovingForward
        self.iconForMovingBackwards = calendarOrg.iconForMovingBackwards
        self.items = calendarOrg.items
    }
}

public enum DSCalendarEvent {
    case onAppear,
         monthSelected(date: Date?),
         timeSelected(date: AnyCodable?),
         action(parameters: DSActionParameter)
}
