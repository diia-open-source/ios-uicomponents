
import UIKit
import DiiaCommonTypes

/// design_system_code: inputTimeMlcV2
public final class DSInputTimeViewV2: BaseCodeView, DSInputComponentProtocol {
    
    // MARK: - Subviews
    private let titleLabel = UILabel().withParameters(font: FontBook.smallTitle)
    private let datePickerTextField = UITextField()
    private let calendarButton: UIButton = UIButton().withSize(Constants.buttonSize)
    private let instructionsLabel = UILabel().withParameters(font: FontBook.smallTitle)
    private let textFieldContainer = UIView()
    private let roundedContainer = UIView()

    // MARK: - Properties
    private var viewModel: DSInputTimeViewModel?
    private var timeZone: TimeZone = .current
    private var separatorColor: UIColor = .statusGray
    private let datePicker = UIDatePicker()
    private let dateFormatter = DateFormatter()

    // MARK: - Lifecycle
    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        roundedContainer.backgroundColor = .white
        roundedContainer.withBorder(width: 1, color: Constants.borderColor, cornerRadius: 16)
        
        textFieldContainer.addSubview(datePickerTextField)
        datePickerTextField.fillSuperview()
        textFieldContainer.withHeight(24)
        
        let vstack = UIStackView.create(views: [titleLabel, textFieldContainer], spacing: 4)
        
        roundedContainer
            .hstack(
                BoxView(subview: vstack).withConstraints(insets: .init(top: Constants.verticalSpacing, left: Constants.horizontalSpacing, bottom: Constants.verticalSpacing, right: 0)),
                calendarButton,
                spacing: 12,
                alignment: .center,
                padding: .init(top: 0, left: 0, bottom: 0, right: Constants.horizontalSpacing)
            )
        
        stack([
            roundedContainer,
            BoxView(subview: instructionsLabel).withConstraints(insets: .init(top: 0, left: Constants.horizontalSpacing, bottom: 0, right: Constants.horizontalSpacing)),
        ], spacing: 4)

        calendarButton.setImage(
            R.image.ds_time.image?.withRenderingMode(.alwaysOriginal),
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
    }

    public func setupUI(titleFont: UIFont = FontBook.statusFont,
                 textFieldFont: UIFont = FontBook.bigText,
                 errorFont: UIFont = FontBook.smallTitle,
                 errorColor: UIColor = UIColor(AppConstants.Colors.persianRed),
                 instructionColor: UIColor = .black540,
                 separatorColor: UIColor = .statusGray) {
        titleLabel.withParameters(font: titleFont)
        instructionsLabel.withParameters(font: errorFont, textColor: instructionColor)
        datePickerTextField.font = textFieldFont
        self.separatorColor = separatorColor

        setNeedsLayout()
        layoutIfNeeded()
    }

    public func validate() {}

    public func setDayDate(date: Date?) {
        if let date = date {
            datePicker.date = date
            dateUpdated()
        }
    }
    
    public func setState(isActive: Bool) {
        roundedContainer.backgroundColor = isActive ? .white : .init("#F0F3F7")
        titleLabel.textColor = isActive ? .black : .black400
        isUserInteractionEnabled = isActive
    }
    
    public func setTimezone(timeZone: TimeZone) {
        self.timeZone = timeZone
        dateFormatter.timeZone = timeZone
    }
    
    public func setMinMaxDates(minDate: Date?, maxDate: Date?) {
        self.datePicker.minimumDate = minDate
        self.datePicker.maximumDate = maxDate
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

        datePicker.datePickerMode = .time
        datePicker.locale = .init(identifier: "uk_UA")
        datePicker.preferredDatePickerStyle = .wheels

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
    }

    // MARK: - Actions
    @objc private func dateUpdated() {
        hideKeyboard()
        let dateString = dateFormatter.string(from: datePicker.date)
        let formattedStringDate = dateString.formattedPhoneNumber(mask: Constants.dateMask)
        datePickerTextField.text = formattedStringDate
        setDate(formattedStringDate)
    }

    @objc private func hideKeyboard() {
        self.endEditing(true)
    }

    @objc private func calendarClicked() {
        if let dateString = datePickerTextField.text,
           let date = dateFormatter.date(from: dateString),
           dateString.count == Constants.maxDateSymbols {
            datePicker.date = date
        } else {
            datePicker.date = Date()
        }
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
extension DSInputTimeViewV2 {
    private enum Constants {
        static let inputCode = "inputTime"
        static let dateMask: String = "XX : XX"
        static let dateFormat = "HH : mm"
        static let outputDateFormat = "HH:mm"
        static let maxDateSymbols = 7
        static let separatorHeight: CGFloat = 2
        static let buttonSize: CGSize = .init(width: 24, height: 24)
        static let stackSpacing: CGFloat = 8
        static let borderColor = UIColor("#C5D9E9")
        static let verticalSpacing: CGFloat = 12
        static let horizontalSpacing: CGFloat = 16
        static let contentStackPadding: UIEdgeInsets = .init(top: 6, left: 0, bottom: 0, right: 0)
        static let bottomStackPadding: UIEdgeInsets = .init(top: 8, left: 0, bottom: 0, right: 0)
    }
}



