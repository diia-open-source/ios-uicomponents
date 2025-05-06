
import UIKit
import DiiaCommonTypes

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

public class DSInputDateTimeViewModel {
    public let componentId: String?
    public let id: String?
    public let maxDate: String?
    public let minDate: String?
    public let inputCode: String?
    public let inputDateMlc: DSInputDateModel?
    public let inputTimeMlc: DSInputTimeModel?
    public let mandatory: Bool?
    public let timezone: TimeZone
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
        timezone: TimeZone = .current,
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
        self.timezone = timezone
        self.onChange = onChange
    }
}

/// design_system_code: inputDateTimeOrg
public class DSInputDateTimeView: BaseCodeView, DSInputComponentProtocol {
    private let stack = UIStackView.create(spacing: Constants.stackSpacing)
    private var viewModel: DSInputDateTimeViewModel?
    private var dateString: String?
    private var timeString: String?
    private var selectedDate: Date?
    
    private var inputDateView: DSInputDateView?
    private var inputTimeView: DSInputTimeView?
    private lazy var dateValidator = TextValidator.date(minDate: nil, maxDate: nil, dateFormatter: outputDateFormatter)
    
    private let dayDateFormatter = DateFormatter()
    private let outputDateFormatter = DateFormatter()
    private var timezone = TimeZone.current {
        didSet {
            dayDateFormatter.timeZone = timezone
            outputDateFormatter.timeZone = timezone
            inputDateView?.setTimezone(timeZone: timezone)
            inputTimeView?.setTimezone(timeZone: timezone)
        }
    }
    
    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        stack.fillSuperview()
        dayDateFormatter.dateFormat = Constants.dateFormat
        dayDateFormatter.locale = Locale(identifier: "uk_UA")
        outputDateFormatter.calendar = Calendar(identifier: .iso8601)
        outputDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        outputDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        outputDateFormatter.dateFormat = Constants.outputDateFormat
    }
    
    public func configure(viewModel: DSInputDateTimeViewModel) {
        self.accessibilityIdentifier = viewModel.componentId
        self.viewModel = viewModel
        stack.safelyRemoveArrangedSubviews()
        let minDate: Date? = viewModel.minDate != nil ? outputDateFormatter.date(from: viewModel.minDate ?? .empty) : nil
        let maxDate: Date? = viewModel.maxDate != nil ? outputDateFormatter.date(from: viewModel.maxDate ?? .empty) : nil
        
        dateValidator = .date(
            minDate: minDate,
            maxDate: maxDate,
            dateFormatter: outputDateFormatter)
        if let data = viewModel.inputDateMlc {
            let inputView = DSInputDateView()
            self.inputDateView = inputView
            stack.addArrangedSubview(inputView)
            
            let vm = DSInputDateViewModel(
                componentId: data.componentId,
                id: data.id,
                inputCode: data.inputCode,
                title: data.label,
                placeholder: R.Strings.general_date_picker_hint.localized(),
                validators: [],
                defaultText: data.value,
                instructionsText: data.hint,
                enableManualEnter: false) { [weak self] text in
                    self?.onDateChanged(date: text)
                }
            inputView.configure(viewModel: vm)
        }
        if let data = viewModel.inputTimeMlc {
            let vm = DSInputTimeViewModel(
                componentId: data.componentId,
                id: data.id,
                inputCode: data.inputCode,
                title: data.label,
                placeholder: R.Strings.general_time_picker_hint.localized(),
                validators: [],
                defaultText: data.value,
                instructionsText: data.hint) { [weak self] text in
                    self?.onTimeChanged(time: text)
                }
            
            let view = DSInputTimeView()
            self.inputTimeView = view
            stack.addArrangedSubview(view)

            view.configure(viewModel: vm)
            if let value = data.value, let date = outputDateFormatter.date(from: value) {
                inputTimeView?.setDayDate(date: date)
            } else {
                inputTimeView?.isUserInteractionEnabled = false
            }
        }
        self.timezone = viewModel.timezone
        inputDateView?.setMinMaxDates(minDate: minDate, maxDate: maxDate)
        inputTimeView?.setMinMaxDates(minDate: minDate, maxDate: maxDate)
    }
    
    public func isValid() -> Bool {
        if let selectedDate = selectedDate {
            let value = outputDateFormatter.string(from: selectedDate)
            return dateValidator.isValid(value: value)
        }
        return viewModel?.mandatory == false
    }
    
    public func inputCode() -> String {
        return viewModel?.inputCode ?? ""
    }
    
    public func inputData() -> DiiaCommonTypes.AnyCodable? {
        if let date = selectedDate {
            return .string(outputDateFormatter.string(from: date))
        }
        return .null
    }
    
    // MARK: - Private
    private func onDateChanged(date: String) {
        self.dateString = date
        self.timeString = nil
        if let dayDate = inputDateView?.outputFormatter.date(from: date) {
            inputTimeView?.setDayDate(date: dayDate)
            inputTimeView?.isUserInteractionEnabled = true
        }
        updateDate()
    }
    
    private func onTimeChanged(time: String) {
        self.timeString = time
        updateDate()
    }
    
    private func updateDate() {
        var calendar = Calendar.current
        calendar.timeZone = timezone
        calendar.locale = Locale(identifier: "uk_UA")
        if let day = dateString, let date = inputDateView?.outputFormatter.date(from: day) {
            var dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
            if let timeArray = timeString?.split(separator: ":").compactMap({ Int($0) }), timeArray.count >= 2 {
                dateComponents.hour = timeArray[0]
                dateComponents.minute = timeArray[1]
                dateComponents.second = 0
            }
            selectedDate = calendar.date(from: dateComponents)
        } else {
            selectedDate = nil
        }
        if let selectedDate = selectedDate {
            viewModel?.onChange?(outputDateFormatter.string(from: selectedDate))
            return
        }
        viewModel?.onChange?(nil)
    }
}

private extension DSInputDateTimeView {
    enum Constants {
        static let stackSpacing: CGFloat = 16
        static let dateFormat = "dd.MM.yyyy"
        static let timeFormat = "HH:mm"
        static let outputDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    }
}
