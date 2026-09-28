
import UIKit
import DiiaCommonTypes

public struct DSInputTimeModel: Codable {
    public let componentId: String?
    public let id: String?
    public let inputCode: String?
    public let placeholder: String
    public let label: String
    public let value: String?
    public let hint: String?
    public let dateFormat: String?
    public let mandatory: Bool?

    public init(componentId: String?, id: String?, inputCode: String?, placeholder: String, label: String, value: String?, hint: String?, dateFormat: String?, mandatory: Bool?) {
        self.componentId = componentId
        self.id = id
        self.inputCode = inputCode
        self.placeholder = placeholder
        self.label = label
        self.value = value
        self.hint = hint
        self.dateFormat = dateFormat
        self.mandatory = mandatory
    }
}

public struct DSInputTimeViewModel {
    public let componentId: String?
    public let id: String?
    public let inputCode: String?
    public let title: String
    public let placeholder: String
    public let validators: [TextValidationErrorGenerator]
    public let defaultText: String?
    public let instructionsText: String?
    public var onChange: ((String) -> Void)?
    
    public init(
        componentId: String? = nil,
        id: String? = nil,
        inputCode: String? = nil,
        title: String,
        placeholder: String,
        validators: [TextValidationErrorGenerator] = [],
        defaultText: String? = nil,
        instructionsText: String? = nil,
        onChange: ((String) -> Void)? = nil
    ) {
        self.componentId = componentId
        self.id = id
        self.inputCode = inputCode
        self.title = title
        self.placeholder = placeholder
        self.validators = validators
        self.defaultText = defaultText
        self.instructionsText = instructionsText
        self.onChange = onChange
    }
}

/// design_system_code: inputTimeMlc
public final class DSInputTimeView: BaseCodeView, DSInputComponentProtocol {
    
    // MARK: - Subviews
    private let titleLabel = UILabel().withParameters(font: FontBook.smallTitle)
    private let datePickerTextField = UITextField()
    private let calendarButton: UIButton = UIButton().withSize(Constants.buttonSize)
    private let separator = UIView().withHeight(Constants.separatorHeight)
    private let errorLabel = UILabel().withParameters(font: FontBook.smallTitle)
    private let instructionsLabel = UILabel().withParameters(font: FontBook.smallTitle)
    private let textFieldContainer = UIView()

    private lazy var contentStack = UIStackView.create(.horizontal, views: [textFieldContainer, calendarButton], spacing: Constants.stackSpacing)
    private lazy var bottomStack = UIStackView.create(views: [separator, errorLabel, instructionsLabel], spacing: Constants.stackSpacing)

    // MARK: - Properties
    private var viewModel: DSInputTimeViewModel?
    private var timeZone: TimeZone = .current
    private var separatorColor: UIColor = .statusGray
    private var datePicker = UIDatePicker()
    private let dateFormatter = DateFormatter()
    private var selectedDay: Date?
    private var minDate: Date?
    private var maxDate: Date?

    // MARK: - Lifecycle
    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        addSubview(titleLabel)
        addSubview(contentStack)
        addSubview(bottomStack)

        textFieldContainer.addSubview(datePickerTextField)
        datePickerTextField.fillSuperview()

        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        contentStack.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: Constants.contentStackPadding)
        bottomStack.anchor(top: contentStack.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: Constants.bottomStackPadding)

        calendarButton.setImage(
            R.image.clocks.image?.withRenderingMode(.alwaysOriginal),
            for: .normal)
        calendarButton.addTarget(self, action: #selector(calendarClicked), for: .touchUpInside)

        setupUI()
        setupDateFormatter()
        setupDatePicker()
        addTapGestureRecognizer()
    }

    // MARK: - Public methods
    public func configure(viewModel: DSInputTimeViewModel) {
        self.viewModel = viewModel
        accessibilityIdentifier = viewModel.componentId
        titleLabel.text = viewModel.title

        datePickerTextField.placeholder = viewModel.placeholder
        datePickerTextField.text = viewModel.defaultText

        instructionsLabel.text = viewModel.instructionsText
        instructionsLabel.isHidden = viewModel.instructionsText?.count ?? 0 == 0

        errorLabel.text = nil
        errorLabel.isHidden = true
        updateInstructionsState()
    }

    public func setupUI(titleFont: UIFont = FontBook.statusFont,
                 textFieldFont: UIFont = FontBook.bigText,
                 errorFont: UIFont = FontBook.smallTitle,
                 errorColor: UIColor = UIColor(AppConstants.Colors.persianRed),
                 instructionColor: UIColor = .black540,
                 separatorColor: UIColor = .statusGray) {
        titleLabel.withParameters(font: titleFont)
        errorLabel.withParameters(font: errorFont, textColor: errorColor)
        instructionsLabel.withParameters(font: errorFont, textColor: instructionColor)
        datePickerTextField.font = textFieldFont
        separator.backgroundColor = separatorColor
        self.separatorColor = separatorColor

        setNeedsLayout()
        layoutIfNeeded()
    }

    public func validate() {
        updateInstructionsState()
    }

    public func setDayDate(date: Date?) {
        let inputTime = inputTime()
        selectedDay = date

        guard let date else {
            updateDatePickerRange()
            clearTime()
            return
        }

        let updatedDate = dateByApplyingTime(from: inputTime ?? Date(), to: date)
        updateDatePickerRange(preferredDate: updatedDate)

        guard inputTime != nil, isAllowed(updatedDate) else {
            clearTime()
            return
        }
        dateUpdated()
    }

    public func setDateTime(date: Date) {
        selectedDay = date
        updateDatePickerRange(preferredDate: date)
        dateUpdated()
    }
    
    public func setTimezone(timeZone: TimeZone) {
        self.timeZone = timeZone
        dateFormatter.timeZone = timeZone
        datePicker.timeZone = timeZone
        updateDatePickerRange()
    }
    
    public func setMinMaxDates(minDate: Date?, maxDate: Date?) {
        self.minDate = minDate
        self.maxDate = maxDate
        updateDatePickerRange()
    }
    
    public func updateValidators(validators: [TextValidationErrorGenerator], forceUpdate: Bool = false) {
        guard let viewModel = viewModel else {
            return
        }
        configure(viewModel: DSInputTimeViewModel(
            componentId: viewModel.componentId,
            id: viewModel.id,
            inputCode: viewModel.inputCode,
            title: viewModel.title,
            placeholder: viewModel.placeholder,
            validators: validators,
            defaultText: viewModel.defaultText,
            instructionsText: viewModel.instructionsText,
            onChange: viewModel.onChange
        ))
        if forceUpdate {
            updateInstructionsState()
        }
    }

    // MARK: - Private methods
    private func setupDateFormatter() {
        dateFormatter.dateFormat = Constants.dateFormat
        dateFormatter.locale = Locale(identifier: "uk_UA")
        dateFormatter.timeZone = timeZone
    }
    
    private func setupDatePicker() {
        datePickerTextField.keyboardType = .numberPad
        datePickerTextField.tintColor = datePickerTextField.tintColor
        datePickerTextField.inputView = datePicker

        configure(datePicker: datePicker)

        let toolbar = ToolbarWithTrailingButton(target: self, action: #selector(dateUpdated))
        
        datePickerTextField.inputAccessoryView = toolbar
    }

    private func setDate(_ dateString: String?) {
        guard let dateString = dateString, dateString.count == Constants.maxDateSymbols else {
            viewModel?.onChange?(.empty)
            return
        }
        viewModel?.onChange?(convertDateFormat(inputDate: dateString) ?? .empty)
    }

    private func convertDateFormat(inputDate: String) -> String? {
        guard let date = dateFormatter.date(from: inputDate) else { return nil }

        let dateFormatterOutput = DateFormatter()
        dateFormatterOutput.timeZone = timeZone
        dateFormatterOutput.dateFormat = Constants.outputDateFormat
        return dateFormatterOutput.string(from: date)
    }

    private func dateByApplyingTime(from time: Date, to day: Date) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "uk_UA")
        calendar.timeZone = timeZone

        var components = calendar.dateComponents([.year, .month, .day], from: day)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute
        components.second = 0
        return calendar.date(from: components) ?? day
    }

    private func inputTime() -> Date? {
        guard
            let value = datePickerTextField.text,
            value.count == Constants.maxDateSymbols
        else { return nil }
        return dateFormatter.date(from: value)
    }

    private func isAllowed(_ date: Date) -> Bool {
        if let minDate, date < minDate { return false }
        if let maxDate, date > maxDate { return false }
        return true
    }

    private func clearTime() {
        datePickerTextField.text = nil
        updateInstructionsState()
    }

    private func updateDatePickerRange(preferredDate: Date? = nil) {
        let pickerDate = preferredDate ?? selectedDay.map {
            dateByApplyingTime(from: datePicker.date, to: $0)
        } ?? datePicker.date
        let range = datePickerRange()
        let shouldRebuildPicker = datePicker.minimumDate != range.minDate
            || datePicker.maximumDate != range.maxDate

        if shouldRebuildPicker {
            datePicker = makeDatePicker()
            datePickerTextField.inputView = datePicker
        }

        datePicker.minimumDate = nil
        datePicker.maximumDate = nil
        datePicker.setDate(pickerDate, animated: false)
        datePicker.minimumDate = range.minDate
        datePicker.maximumDate = range.maxDate
        datePicker.setDate(clamped(pickerDate, to: range), animated: false)

        if shouldRebuildPicker, datePickerTextField.isFirstResponder {
            datePickerTextField.reloadInputViews()
        }
    }

    private func makeDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        configure(datePicker: datePicker)
        return datePicker
    }

    private func configure(datePicker: UIDatePicker) {
        datePicker.datePickerMode = .time
        datePicker.locale = .init(identifier: "uk_UA")
        datePicker.timeZone = timeZone
        datePicker.preferredDatePickerStyle = .wheels
    }

    private func datePickerRange() -> (minDate: Date?, maxDate: Date?) {
        guard let selectedDay else { return (minDate, maxDate) }

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        let pickerMinDate = minDate.flatMap {
            calendar.isDate($0, inSameDayAs: selectedDay) ? $0 : nil
        }
        let pickerMaxDate = maxDate.flatMap {
            calendar.isDate($0, inSameDayAs: selectedDay) ? $0 : nil
        }
        return (pickerMinDate, pickerMaxDate)
    }

    private func clamped(
        _ date: Date,
        to range: (minDate: Date?, maxDate: Date?)
    ) -> Date {
        if let minDate = range.minDate, date < minDate { return minDate }
        if let maxDate = range.maxDate, date > maxDate { return maxDate }
        return date
    }

    private func updateInstructionsState() {
        let inputText = datePickerTextField.text ?? .empty
        let errorText = error(for: inputText)
        errorLabel.text = errorText
        errorLabel.isHidden = errorText == nil
        if errorText == nil {
            separator.backgroundColor = inputText.isEmpty ? separatorColor : .black
            datePickerTextField.textColor = .black
        } else {
            separator.backgroundColor = errorLabel.textColor
            datePickerTextField.textColor = errorLabel.textColor
        }
        instructionsLabel.isHidden = !errorLabel.isHidden
            || viewModel?.instructionsText?.count ?? 0 == 0
    }

    private func error(for text: String) -> String? {
        if text.count == 0 { return nil }
        for validator in viewModel?.validators ?? [] {
            if let error = validator.validationError(text: text) {
                return error
            }
        }
        return nil
    }

    private func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(calendarClicked))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }

    // MARK: - Actions
    @objc private func dateUpdated() {
        hideKeyboard()
        let dateString = dateFormatter.string(from: datePicker.date)
        let formattedStringDate = dateString.formattedPhoneNumber(mask: Constants.dateMask)
        datePickerTextField.text = formattedStringDate

        updateInstructionsState()
        setDate(formattedStringDate)
    }

    @objc private func hideKeyboard() {
        self.endEditing(true)
    }

    @objc private func calendarClicked() {
        let time: Date
        if let dateString = datePickerTextField.text,
           let date = dateFormatter.date(from: dateString),
           dateString.count == Constants.maxDateSymbols {
            time = date
        } else {
            time = Date()
        }
        let pickerDate = dateByApplyingTime(from: time, to: selectedDay ?? Date())
        updateDatePickerRange(preferredDate: pickerDate)
        datePickerTextField.becomeFirstResponder()
    }

    // MARK: - DSInputComponentProtocol
    public func isValid() -> Bool {
        guard let inputText = datePickerTextField.text, !inputText.isEmpty else { return false }
        return error(for: inputText) == nil
    }

    public func inputCode() -> String {
        return viewModel?.inputCode ?? viewModel?.id ?? Constants.inputCode
    }
    
    public func inputData() -> AnyCodable? {
        guard let inputText = datePickerTextField.text, !inputText.isEmpty else { return nil }
        return .string(inputText)
    }
    
    public func setOnChangeHandler(_ handler: @escaping Callback) {
        viewModel?.onChange = { _ in handler() }
    }
}

// MARK: - Constants
extension DSInputTimeView {
    private enum Constants {
        static let inputCode = "inputTime"
        static let dateMask: String = "XX : XX"
        static let dateFormat = "HH : mm"
        static let outputDateFormat = "HH:mm"
        static let maxDateSymbols = 7
        static let separatorHeight: CGFloat = 2
        static let buttonSize: CGSize = .init(width: 24, height: 24)
        static let stackSpacing: CGFloat = 8
        static let contentStackPadding: UIEdgeInsets = .init(top: 6, left: 0, bottom: 0, right: 0)
        static let bottomStackPadding: UIEdgeInsets = .init(top: 8, left: 0, bottom: 0, right: 0)
    }
}
