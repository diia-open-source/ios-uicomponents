
import XCTest
@testable import DiiaUIComponents

final class DSInputTimeViewV2Tests: XCTestCase {
    func test_setDayDate_doesNotChangeTime() {
        // Arrange
        let sut = DSInputTimeViewV2()
        var receivedValues: [String] = []
        sut.configure(viewModel: makeViewModel { receivedValues.append($0) })

        // Act
        sut.setDayDate(date: makeDate(year: 2026, month: 9, day: 19, hour: 12, minute: 30))

        // Assert
        XCTAssertTrue(receivedValues.isEmpty)
        XCTAssertNil(sut.inputData())
    }

    func test_setDateTime_changesTime() {
        // Arrange
        let sut = DSInputTimeViewV2()
        var receivedValues: [String] = []
        sut.setTimezone(timeZone: timeZone)
        sut.configure(viewModel: makeViewModel { receivedValues.append($0) })

        // Act
        sut.setDateTime(date: makeDate(year: 2026, month: 9, day: 19, hour: 12, minute: 30))

        // Assert
        XCTAssertEqual(receivedValues, ["12:30"])
    }

    func test_setDayDate_preservesAllowedTime() {
        // Arrange
        let sut = DSInputTimeViewV2()
        var receivedValues: [String] = []
        sut.setTimezone(timeZone: timeZone)
        sut.configure(viewModel: makeViewModel { receivedValues.append($0) })
        sut.setDateTime(date: makeDate(year: 2026, month: 9, day: 19, hour: 12, minute: 30))
        receivedValues.removeAll()

        // Act
        sut.setDayDate(date: makeDate(year: 2026, month: 9, day: 20, hour: 0, minute: 0))

        // Assert
        XCTAssertEqual(receivedValues, ["12:30"])
    }

    func test_setDayDate_clearsDisallowedTime() {
        // Arrange
        let sut = DSInputTimeViewV2()
        var receivedValues: [String] = []
        sut.setTimezone(timeZone: timeZone)
        sut.configure(viewModel: makeViewModel { receivedValues.append($0) })
        sut.setDateTime(date: makeDate(year: 2026, month: 9, day: 19, hour: 12, minute: 30))
        sut.setMinMaxDates(
            minDate: makeDate(year: 2026, month: 9, day: 20, hour: 13, minute: 0),
            maxDate: nil
        )
        receivedValues.removeAll()

        // Act
        sut.setDayDate(date: makeDate(year: 2026, month: 9, day: 20, hour: 0, minute: 0))

        // Assert
        XCTAssertTrue(receivedValues.isEmpty)
        XCTAssertNil(sut.inputData())
    }

    func test_setDayDate_updatesPickerDayAfterTimeWasCleared() {
        // Arrange
        let sut = DSInputTimeViewV2()
        sut.setTimezone(timeZone: timeZone)
        sut.configure(viewModel: makeViewModel { _ in })
        sut.setDateTime(date: makeDate(year: 2026, month: 9, day: 19, hour: 12, minute: 30))
        sut.setMinMaxDates(
            minDate: makeDate(year: 2026, month: 9, day: 20, hour: 13, minute: 0),
            maxDate: nil
        )
        sut.setDayDate(date: makeDate(year: 2026, month: 9, day: 20, hour: 0, minute: 0))
        let boundaryPicker = datePicker(from: sut)

        // Act
        sut.setDayDate(date: makeDate(year: 2026, month: 9, day: 21, hour: 0, minute: 0))

        // Assert
        let picker = datePicker(from: sut)
        let components = calendar.dateComponents([.year, .month, .day], from: picker.date)
        XCTAssertEqual(components.year, 2026)
        XCTAssertEqual(components.month, 9)
        XCTAssertEqual(components.day, 21)
        XCTAssertNil(picker.minimumDate)
        XCTAssertFalse(boundaryPicker === picker)
    }

    func test_dateTimeView_withDateOnly_emitsDate() {
        // Arrange
        let sut = DSInputDateTimeOrgViewV2()
        var receivedValues: [String?] = []

        // Act
        sut.configure(viewModel: makeDateTimeViewModel(
            timeModel: nil,
            onChange: { receivedValues.append($0) }
        ))

        // Assert
        XCTAssertNotNil(receivedValues.last ?? nil)
    }

    func test_dateTimeView_withEmptyTime_doesNotEmitDateTime() {
        // Arrange
        let sut = DSInputDateTimeOrgViewV2()
        var receivedValues: [String?] = []

        // Act
        sut.configure(viewModel: makeDateTimeViewModel(
            timeModel: DSInputTimeModel(
                componentId: nil,
                id: nil,
                inputCode: nil,
                placeholder: "Select time",
                label: "Time",
                value: nil,
                hint: nil,
                dateFormat: "HH:mm",
                mandatory: true
            ),
            onChange: { receivedValues.append($0) }
        ))

        // Assert
        XCTAssertNil(receivedValues.last ?? nil)
    }

    private func makeViewModel(onChange: @escaping (String) -> Void) -> DSInputTimeViewModel {
        DSInputTimeViewModel(
            title: "Time",
            placeholder: "Select time",
            onChange: onChange
        )
    }

    private func makeDateTimeViewModel(
        timeModel: DSInputTimeModel?,
        onChange: @escaping (String?) -> Void
    ) -> DSInputDateTimeViewModel {
        DSInputDateTimeViewModel(
            componentId: nil,
            id: nil,
            maxDate: nil,
            minDate: nil,
            inputCode: "dateTime",
            inputDateMlc: DSInputDateModel(
                componentId: nil,
                id: nil,
                inputCode: nil,
                blocker: nil,
                mandatory: true,
                label: "Date",
                value: "2026-09-19T00:00:00.000Z",
                hint: nil,
                validation: nil
            ),
            inputTimeMlc: timeModel,
            mandatory: true,
            displayTimezone: timeZone,
            onChange: onChange
        )
    }

    private func makeDate(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
        return calendar.date(from: DateComponents(
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute
        )) ?? Date()
    }

    private func datePicker(from sut: DSInputTimeViewV2) -> UIDatePicker {
        let picker = Mirror(reflecting: sut).children.first {
            $0.label == "datePicker"
        }?.value as? UIDatePicker
        XCTAssertNotNil(picker)
        return picker ?? UIDatePicker()
    }

    private var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        return calendar
    }

    private var timeZone: TimeZone {
        TimeZone(secondsFromGMT: 0) ?? .current
    }
}
