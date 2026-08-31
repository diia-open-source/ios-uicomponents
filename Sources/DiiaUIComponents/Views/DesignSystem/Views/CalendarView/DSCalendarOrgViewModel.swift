
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
    public let currentTimeMlc: DSCurrentTimeMlc?
    
    public let isOldVersion: Bool
    public let legends: [DSLegendGroupMlc]?
    public var eventHandler: ((ConstructorItemEvent) -> ())?
    
    public init(calendarOrg: DSCalendarOrg,
                inputCode: String? = nil) {
        self.calendarOrg = .init(value: DSCalendarModel(
            iconForMovingForward: calendarOrg.iconForMovingForward?.iconAtm,
            iconForMovingBackwards: calendarOrg.iconForMovingBackwards?.iconAtm,
            items: calendarOrg.items))
        self.currentTimeMlc = calendarOrg.currentTimeMlc
        self.stubMessage.value = calendarOrg.stubMessageMlc
        if let code = inputCode {
            self.inputCode = code
        }
        if let displayMonth = calendarOrg.currentTimeMlc?.displayMonth,
           let selectedPeriod = monthYearFormatter.date(from: displayMonth) {
            self.selectedPeriod.value = selectedPeriod
        }
        self.isOldVersion = true
        self.legends = nil
    }
    
    public init(calendarOrg: DSCalendarOrgV2,
                inputCode: String? = nil) {
        self.calendarOrg = .init(value: DSCalendarModel(
            iconForMovingForward: calendarOrg.iconForMovingForward,
            iconForMovingBackwards: calendarOrg.iconForMovingBackwards,
            items: calendarOrg.items))
        self.currentTimeMlc = calendarOrg.currentTimeMlc
        self.legends = calendarOrg.legends?.map({$0.legendGroupMlc})
        self.paginationMessage.value = calendarOrg.paginationMessageMlc
        if let displayMonth = calendarOrg.currentTimeMlc?.displayMonth,
           let selectedPeriod = monthYearFormatter.date(from: displayMonth) {
            self.selectedPeriod.value = selectedPeriod
        }
        self.isOldVersion = false
        if let code = inputCode {
            self.inputCode = code
        }
    }
    
    private var monthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "uk_UA")
        formatter.dateFormat = "MM.yyyy"
        formatter.timeZone = TimeZone(identifier: "Europe/Kyiv")!
        return formatter
    }()
}

public struct DSCalendarModel {
    public let iconForMovingForward: DSIconModel?
    public let iconForMovingBackwards: DSIconModel?
    public let items: [DSCalendarItem]
    
    init(iconForMovingForward: DSIconModel?, iconForMovingBackwards: DSIconModel?, items: [DSCalendarItem]) {
        self.iconForMovingForward = iconForMovingForward
        self.iconForMovingBackwards = iconForMovingBackwards
        self.items = items
    }
    
    public init(calendarOrg: DSCalendarOrg) {
        self.iconForMovingForward = calendarOrg.iconForMovingForward?.iconAtm
        self.iconForMovingBackwards = calendarOrg.iconForMovingBackwards?.iconAtm
        self.items = calendarOrg.items
    }
    
    public init(calendarOrg: DSCalendarOrgV2) {
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
