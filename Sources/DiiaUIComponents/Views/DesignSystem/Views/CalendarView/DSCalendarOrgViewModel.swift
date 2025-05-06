
import Foundation
import DiiaCommonTypes

public class DSCalendarOrgViewModel {
    
    public var currentTimeMlc: DSCurrentTimeMlc?
    public var backBtn: DSIconModel?
    public var forwardBtn: DSIconModel?
    public var items: [DSCalendarItem]?
    public var inputCode: String?
    
    public let calendarOrg: Observable<DSCalendarOrg>
    public let isLoading = Observable<Bool>(value: false)
    public let selectedPeriod = Observable<Date?>(value: nil)
    public let selectedDate = Observable<Date?>(value: nil)
    public let selectedChipData = Observable<AnyCodable?>(value: nil)
    
    public var eventHandler: ((ConstructorItemEvent) -> ())?
    
    public init(calendarOrg: DSCalendarOrg,
                inputCode: String? = nil) {
        self.calendarOrg = .init(value: calendarOrg)
        self.currentTimeMlc = calendarOrg.currentTimeMlc
        self.backBtn = calendarOrg.iconForMovingBackwards?.iconAtm
        self.forwardBtn = calendarOrg.iconForMovingForward?.iconAtm
        self.items = calendarOrg.items
        if let code = inputCode {
            self.inputCode = code
        }
    }
}

public enum DSCalendarEvent {
    case onAppear,
         monthSelected(date: Date?),
         timeSelected(date: AnyCodable?),
         action(parameters: DSActionParameter)
}
