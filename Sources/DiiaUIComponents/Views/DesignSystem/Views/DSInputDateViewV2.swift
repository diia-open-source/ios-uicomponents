
import UIKit
import DiiaCommonTypes

/// design_system_code: inputDateMlcV2
public final class DSInputDateViewV2: BaseCodeView, DSInputComponentProtocol {
    
    // MARK: - Subviews
    private let titleLabel = UILabel().withParameters(font: FontBook.smallTitle)
    private let dateTextField = UITextField()
    private let datePickerTextField = UITextField()
    private let calendarButton: UIButton = UIButton().withSize(Constants.buttonSize)
    private let instructionsLabel = UILabel().withParameters(font: FontBook.smallTitle)
    private let textFieldContainer = UIView()
    private let roundedContainer = UIView()
    
    // MARK: - Properties
    private var viewModel: DSInputDateViewModel?
    private let datePicker = UIDatePicker()
    private let dateFormatter = DateFormatter()
    private let inputFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = Constants.inputDateFormat
        return formatter
    }()
    public let outputFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = Constants.outputDateFormat
        return formatter
    }()
    private var timeZone: TimeZone = .current
    
    // MARK: - Lifecycle
    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        roundedContainer.backgroundColor = .white
        roundedContainer.withBorder(width: 1, color: Constants.borderColor, cornerRadius: 16)
        
        textFieldContainer.addSubview(dateTextField)
        textFieldContainer.addSubview(datePickerTextField)
        dateTextField.fillSuperview()
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
            R.image.ds_calendar.image?.withRenderingMode(.alwaysOriginal),
            for: .normal
        )
        calendarButton.addTarget(self, action: #selector(calendarClicked), for: .touchUpInside)

        setupUI()
        setupDateFormatter()
        setupTextField()
        setupDatePicker()
        addTapGestureRecognizer()
    }

    // MARK: - Public methods
    public func configure(viewModel: DSInputDateViewModel) {
        self.viewModel = viewModel
        accessibilityIdentifier = viewModel.componentId
        titleLabel.text = viewModel.title

        dateTextField.placeholder = viewModel.placeholder
        datePickerTextField.placeholder = viewModel.placeholder
        
        if dateTextField.text?.isEmpty == true, let dateStr = viewModel.defaultText, let date = inputFormatter.date(from: dateStr) {
            datePicker.date = date
            dateUpdated()
        }

        instructionsLabel.text = viewModel.instructionsText
        instructionsLabel.isHidden = viewModel.instructionsText?.count ?? 0 == 0
        
        dateTextField.isHidden = !viewModel.enableManualEnter
        datePickerTextField.isHidden = viewModel.enableManualEnter
    }

    public func setupUI(titleFont: UIFont = FontBook.statusFont,
                 textFieldFont: UIFont = FontBook.bigText,
                 errorFont: UIFont = FontBook.smallTitle,
                 errorColor: UIColor = UIColor(AppConstants.Colors.persianRed),
                 instructionColor: UIColor = .black540) {
        titleLabel.withParameters(font: titleFont)
        instructionsLabel.withParameters(font: errorFont, textColor: instructionColor)
        dateTextField.font = textFieldFont
        datePickerTextField.font = textFieldFont

        setNeedsLayout()
        layoutIfNeeded()
    }

    public func setTimezone(timeZone: TimeZone) {
        self.timeZone = timeZone
        dateFormatter.timeZone = timeZone
        outputFormatter.timeZone = timeZone
        inputFormatter.timeZone = timeZone
    }
    
    public func setMinMaxDates(minDate: Date?, maxDate: Date?) {
        self.datePicker.minimumDate = minDate
        self.datePicker.maximumDate = maxDate
    }
    
    public func validate() {}

    public func updateValidators(validators: [TextValidationErrorGenerator], forceUpdate: Bool = false) {
        guard let viewModel = viewModel else {
            return
        }
        configure(viewModel: DSInputDateViewModel(
            componentId: viewModel.componentId,
            id: viewModel.id,
            inputCode: viewModel.inputCode,
            title: viewModel.title,
            placeholder: viewModel.placeholder,
            validators: validators,
            defaultText: viewModel.defaultText,
            instructionsText: viewModel.instructionsText,
            enableManualEnter: viewModel.enableManualEnter,
            onChange: viewModel.onChange
        ))
    }

    // MARK: - Private methods
    private func setupDateFormatter() {
        dateFormatter.dateFormat = Constants.dateFormat
        dateFormatter.locale = Locale(identifier: "uk_UA")
        dateFormatter.timeZone = timeZone
    }

    private func setupTextField() {
        dateTextField.delegate = self
        dateTextField.autocorrectionType = .no
        dateTextField.keyboardType = .numberPad
    }

    private func setupDatePicker() {
        datePickerTextField.keyboardType = .numberPad
        datePickerTextField.tintColor = (viewModel?.enableManualEnter ?? false) ? datePickerTextField.tintColor : .clear
        datePickerTextField.inputView = datePicker
        datePickerTextField.translatesAutoresizingMaskIntoConstraints = false

        datePicker.datePickerMode = .date
        datePicker.locale = .init(identifier: "uk_UA")
        datePicker.preferredDatePickerStyle = .wheels
        
        let toolbar = ToolbarWithTrailingButton(target: self, action: #selector(dateUpdated))
        
        datePickerTextField.inputAccessoryView = toolbar
    }

    private func setDate(_ dateString: String?) {
        guard let dateString, dateString.count == Constants.maxDateSymbols else {
            viewModel?.onChange?(.empty)
            return
        }
        viewModel?.onChange?(convertDateFormat(inputDate: dateString) ?? .empty)
    }

    private func convertDateFormat(inputDate: String) -> String? {
        guard let date = dateFormatter.date(from: inputDate) else { return nil }

        return outputFormatter.string(from: date)
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
        let formattedStringDate = formattedStringDate(dateString, mask: Constants.dateMask)
        dateTextField.text = formattedStringDate
        datePickerTextField.text = formattedStringDate

        setDate(formattedStringDate)
    }

    @objc private func hideKeyboard() {
        self.endEditing(true)
    }

    @objc private func calendarClicked() {
        if let dateString = dateTextField.text,
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
        guard let inputText = dateTextField.text, !inputText.isEmpty else { return false }
        return true
    }

    public func inputCode() -> String {
        return viewModel?.inputCode ?? viewModel?.id ?? Constants.inputCode
    }
    
    public func inputData() -> AnyCodable? {
        guard let inputText = dateTextField.text, !inputText.isEmpty else { return nil }
        return .string(inputText)
    }
    
    public func setOnChangeHandler(_ handler: @escaping Callback) {
        viewModel?.onChange = { _ in handler() }
    }
}

extension DSInputDateViewV2: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == dateTextField {
            let newString = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
            let formattedStringDate = formattedStringDate(newString, mask: Constants.dateMask)
            dateTextField.text = formattedStringDate
            setDate(formattedStringDate)
            return false
        }
        return true
    }

    private func formattedStringDate(_ stringDate: String, mask: String) -> String {
        let clearDigitText = stringDate.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

        var result = ""
        var index = clearDigitText.startIndex
        for ch in mask where index < clearDigitText.endIndex {
            if ch == "X" {
                result.append(clearDigitText[index])
                index = clearDigitText.index(after: index)
            } else {
                result.append(ch)
            }
        }
        let charactersCount = result.count
        if charactersCount == 1, let dateInt = Int(result), dateInt > 3 {
            result = "0" + result
        }
        if charactersCount == 2, let dateInt = Int(result), dateInt > 31 {
            result = "0" + result.prefix(1) + " / 0" + result.suffix(1)
        }
        if charactersCount == 6, let dateInt = Int(result.suffix(1)), dateInt > 1 {
            result = result.prefix(5) + "0" + String(dateInt)
        }
        if charactersCount == 7, let dateInt = Int(result.suffix(2)), dateInt > 12 {
            result = String(result.prefix(6))
        }
        return result
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Constants
extension DSInputDateViewV2 {
    private enum Constants {
        static let inputCode = "inputDate"
        static let dateMask: String = "XX / XX / XXXX"
        static let dateFormat = "dd / MM / yyyy"
        static let inputDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        static let outputDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        static let maxDateSymbols = 14
        static let separatorHeight: CGFloat = 2
        static let buttonSize: CGSize = .init(width: 24, height: 24)
        static let stackSpacing: CGFloat = 8
        static let verticalSpacing: CGFloat = 12
        static let horizontalSpacing: CGFloat = 16
        static let borderColor = UIColor("#C5D9E9")
        static let contentStackPadding: UIEdgeInsets = .init(top: 6, left: 16, bottom: 12, right: 16)
        static let bottomStackPadding: UIEdgeInsets = .init(top: 8, left: 16, bottom: 12, right: 0)
    }
}

