
import UIKit
import DiiaCommonTypes

// MARK: - Model
public struct DSInputDateTimeModel: Codable {
    public let componentId: String?
    public let id: String?
    public let maxDate: String?
    public let minDate: String?
    public let inputCode: String?
    public let inputDateMlc: DSInputDateModel?
    public let inputTimeMlc: DSInputTimeModel?

    public init(componentId: String?, id: String?, maxDate: String?, minDate: String?, inputCode: String?, inputDateMlc: DSInputDateModel?, inputTimeMlc: DSInputTimeModel?) {
        self.componentId = componentId
        self.id = id
        self.maxDate = maxDate
        self.minDate = minDate
        self.inputCode = inputCode
        self.inputDateMlc = inputDateMlc
        self.inputTimeMlc = inputTimeMlc
    }
}

// MARK: - ViewModel
public final class DSInputDateTimeViewModel {
    public static let ukraineTimeZone: TimeZone = TimeZone(identifier: "Europe/Kyiv")
        ?? TimeZone(identifier: "Europe/Kiev")
        ?? .current

    public let componentId: String?
    public let id: String?
    public let maxDate: String?
    public let minDate: String?
    public let inputCode: String?
    public let inputDateMlc: DSInputDateModel?
    public let inputTimeMlc: DSInputTimeModel?
    public let mandatory: Bool?
    public let displayTimezone: TimeZone
    public var onChange: ((String?) -> Void)?

    init(
        componentId: String?,
        id: String?,
        maxDate: String?,
        minDate: String?,
        inputCode: String?,
        inputDateMlc: DSInputDateModel?,
        inputTimeMlc: DSInputTimeModel?,
        mandatory: Bool? = false,
        displayTimezone: TimeZone = DSInputDateTimeViewModel.ukraineTimeZone,
        onChange: ((String?) -> Void)? = nil
    ) {
        self.componentId = componentId
        self.id = id
        self.maxDate = maxDate
        self.minDate = minDate
        self.inputCode = inputCode
        self.inputDateMlc = inputDateMlc
        self.inputTimeMlc = inputTimeMlc
        self.mandatory = mandatory
        self.displayTimezone = displayTimezone
        self.onChange = onChange
    }
}

// MARK: - View
/// design_system_code: inputDateTimeOrg
public final class DSInputDateTimeView: BaseCodeView, DSInputComponentProtocol {

    // MARK: Subviews
    private let stack = UIStackView.create(spacing: Constants.stackSpacing)
    private var inputDateView: DSInputDateView?
    private var inputTimeView: DSInputTimeView?

    // MARK: State
    private var viewModel: DSInputDateTimeViewModel?
    private var dateString: String?
    private var timeString: String?
    private var selectedDate: Date?
    private var isConfiguring = false

    private var displayTimeZone: TimeZone = DSInputDateTimeViewModel.ukraineTimeZone

    // MARK: Formatting
    private let outputDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = Constants.outputDateFormat
        return formatter
    }()
    
    private lazy var calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "uk_UA")
        calendar.timeZone = displayTimeZone
        return calendar
    }()

    private lazy var dateValidator = TextValidator.date(
        minDate: nil,
        maxDate: nil,
        dateFormatter: outputDateFormatter
    )

    // MARK: - Setup
    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        stack.fillSuperview()
    }

    // MARK: - Configuration
    public func configure(viewModel: DSInputDateTimeViewModel) {
        isConfiguring = true
        accessibilityIdentifier = viewModel.componentId
        self.viewModel = viewModel
        displayTimeZone = viewModel.displayTimezone
        calendar.timeZone = displayTimeZone

        resetSelection()
        stack.safelyRemoveArrangedSubviews()
        inputDateView = nil
        inputTimeView = nil

        let minDate = date(fromWireString: viewModel.minDate)
        let maxDate = date(fromWireString: viewModel.maxDate)
        dateValidator = .date(minDate: minDate, maxDate: maxDate, dateFormatter: outputDateFormatter)

        setupDateView(with: viewModel.inputDateMlc)
        setupTimeView(with: viewModel.inputTimeMlc)
        
        inputDateView?.setTimezone(timeZone: displayTimeZone)
        inputTimeView?.setTimezone(timeZone: displayTimeZone)
        inputDateView?.setMinMaxDates(minDate: minDate, maxDate: maxDate)
        inputTimeView?.setMinMaxDates(minDate: minDate, maxDate: maxDate)
        isConfiguring = false
        if dateString != nil || timeString != nil {
            recalculateSelectedDate()
        }
    }

    // MARK: - DSInputComponentProtocol
    public func isValid() -> Bool {
        guard let selectedDate else {
            return viewModel?.mandatory == false
        }
        return dateValidator.isValid(value: outputDateFormatter.string(from: selectedDate))
    }

    public func inputCode() -> String {
        return viewModel?.inputCode ?? ""
    }

    public func inputData() -> DiiaCommonTypes.AnyCodable? {
        guard let selectedDate else { return .null }
        return .string(outputDateFormatter.string(from: selectedDate))
    }

    // MARK: - Child views
    private func setupDateView(with model: DSInputDateModel?) {
        guard let model else { return }

        let view = DSInputDateView()
        inputDateView = view
        stack.addArrangedSubview(view)
        view.setTimezone(timeZone: displayTimeZone)

        let viewModel = DSInputDateViewModel(
            componentId: model.componentId,
            id: model.id,
            inputCode: model.inputCode,
            title: model.label,
            placeholder: R.Strings.general_date_picker_hint.localized(),
            validators: [],
            defaultText: model.value,
            instructionsText: model.hint,
            enableManualEnter: false
        ) { [weak self] text in
            self?.onDateChanged(date: text)
        }
        view.configure(viewModel: viewModel)
    }

    private func setupTimeView(with model: DSInputTimeModel?) {
        guard let model else { return }

        let view = DSInputTimeView()
        inputTimeView = view
        stack.addArrangedSubview(view)
        view.setTimezone(timeZone: displayTimeZone)

        let viewModel = DSInputTimeViewModel(
            componentId: model.componentId,
            id: model.id,
            inputCode: model.inputCode,
            title: model.label,
            placeholder: R.Strings.general_time_picker_hint.localized(),
            validators: [],
            defaultText: model.value,
            instructionsText: model.hint
        ) { [weak self] text in
            self?.onTimeChanged(time: text)
        }
        view.configure(viewModel: viewModel)
        
        if let value = model.value, let date = outputDateFormatter.date(from: value) {
            view.setDateTime(date: date)
        } else {
            view.isUserInteractionEnabled = false
        }
    }

    // MARK: - Change handling
    private func onDateChanged(date: String) {
        dateString = date
        timeString = nil

        if let dayDate = inputDateView?.outputFormatter.date(from: date) {
            inputTimeView?.setDayDate(date: dayDate)
            inputTimeView?.isUserInteractionEnabled = true
        }
        recalculateSelectedDate()
    }

    private func onTimeChanged(time: String) {
        timeString = time
        recalculateSelectedDate()
    }

    private func recalculateSelectedDate() {
        selectedDate = makeSelectedDate()
        guard !isConfiguring else { return }
        viewModel?.onChange?(selectedDate.map(outputDateFormatter.string(from:)))
    }

    // MARK: - Helpers
    private func makeSelectedDate() -> Date? {
        guard
            let dateString,
            let day = inputDateView?.outputFormatter.date(from: dateString)
        else { return nil }

        var components = calendar.dateComponents([.year, .month, .day], from: day)
        if inputTimeView != nil {
            guard let time = parseTime(timeString) else { return nil }
            components.hour = time.hour
            components.minute = time.minute
            components.second = 0
        }
        return calendar.date(from: components)
    }

    private func parseTime(_ string: String?) -> (hour: Int, minute: Int)? {
        guard
            let components = string?.split(separator: ":").compactMap({ Int($0) }),
            components.count >= 2
        else { return nil }
        return (components[0], components[1])
    }

    private func date(fromWireString string: String?) -> Date? {
        guard let string, !string.isEmpty else { return nil }
        return outputDateFormatter.date(from: string)
    }

    private func resetSelection() {
        dateString = nil
        timeString = nil
        selectedDate = nil
    }
}

// MARK: - Constants
private extension DSInputDateTimeView {
    enum Constants {
        static let stackSpacing: CGFloat = 16
        static let outputDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    }
}
