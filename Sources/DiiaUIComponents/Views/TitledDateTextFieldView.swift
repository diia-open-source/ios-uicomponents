
import UIKit

public class TitledDateTextFieldView: UIView {
    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateTextField: UITextField!
    @IBOutlet private weak var datePickerTextField: UITextField!
    @IBOutlet private weak var calendarButton: UIButton!
    @IBOutlet private weak var underlineView: UIView!
    @IBOutlet private weak var errorLabel: UILabel!
    
    // MARK: - Properties
    private var dateSeparator: String = "/"
    private var hideErrorMessage: Bool = true
    private var minDate: Date?
    private var maxDate: Date?
    private var onFinishEditing: ((Date?) -> Void)?
    
    private let datePicker = UIDatePicker()
    private let dateFormatter = DateFormatter()
    
    private var enteredDate: Date? {
        didSet {
            onFinishEditing?(enteredDate)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib(bundle: Bundle.module)

        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fromNib(bundle: Bundle.module)
    }
    
    // MARK: - Life Cycle
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    // MARK: - Setup
    public func setupUI(dateSeparator: String = "/",
                        titleFont: UIFont = FontBook.smallTitle,
                        textFieldFont: UIFont = FontBook.bigText,
                        errorFont: UIFont = FontBook.smallTitle,
                        errorColor: UIColor = Constants.errorColor) {
        self.dateSeparator = dateSeparator
        titleLabel.font = titleFont
        dateTextField.font = textFieldFont
        datePickerTextField.font = textFieldFont
        errorLabel.font = errorFont
        errorLabel.textColor = errorColor
    }
    
    public func configure(title: String, placeholder: String, error: String? = nil, minDate: Date? = nil, maxDate: Date? = nil, enableManualEnter: Bool = true, onFinishEditing: ((Date?) -> Void)?) {
        titleLabel.text = title
        dateTextField.placeholder = placeholder
        datePickerTextField.placeholder = placeholder
        
        hideErrorMessage = error == nil
        errorLabel.text = error
        
        self.minDate = minDate
        self.maxDate = maxDate
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        
        dateTextField.isHidden = !enableManualEnter
        datePickerTextField.isHidden = enableManualEnter
        
        self.onFinishEditing = onFinishEditing
    }
    
    // MARK: - Private methods
    private func setup() {
        setupUI()
        setupDateFormatter()
        setupTextField()
        setupDatePicker()
        
        calendarButton.setImage(R.image.calendar.image?.withRenderingMode(.alwaysOriginal), for: .normal)
        underlineView.backgroundColor = Constants.defaultSeparatorColor
        
        errorLabel.isHidden = hideErrorMessage
    }
    
    private func setupDateFormatter() {
        dateFormatter.dateFormat = "dd" + dateSeparator + "MM" + dateSeparator + "yyyy"
        dateFormatter.locale = Locale(identifier: "uk_UA")
        dateFormatter.timeZone = TimeZone.current
    }
    
    private func setupTextField() {
        dateTextField.delegate = self
        dateTextField.autocorrectionType = .no
    }
    
    private func setupDatePicker() {
        datePickerTextField.inputView = datePicker
        datePickerTextField.translatesAutoresizingMaskIntoConstraints = false

        datePicker.datePickerMode = .date
        datePicker.locale = .init(identifier: "uk_UA")
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }

        let toolbar = ToolbarWithTrailingButton(target: self, action: #selector(dateUpdated))
        
        datePickerTextField.inputAccessoryView = toolbar
    }
    
    private func setDate(_ dateString: String?) {
        if let dateString = dateString,
           !dateString.isEmpty,
           dateString.count == 10,
           let date = dateFormatter.date(from: dateString),
           checkIsDateInInterval(date) {
            enteredDate = date
            showErrorEnteredDate(false)
        } else {
            enteredDate = nil
            showErrorEnteredDate(true)
        }
    }
    
    private func checkIsDateInInterval(_ date: Date) -> Bool {
        if let minDate = minDate, let maxDate = maxDate {
            return date >= minDate && date <= maxDate
        } else if let minDate = minDate, maxDate == nil {
            return date >= minDate
        } else if minDate == nil, let maxDate = maxDate {
            return date <= maxDate
        }
        return true
    }
    
    private func showErrorEnteredDate(_ isError: Bool) {
        dateTextField.textColor = isError ?  Constants.errorColor : .black
        underlineView.backgroundColor = isError ? Constants.errorColor : Constants.selectedSeparatorColor
        errorLabel.isHidden = !isError || hideErrorMessage
    }
    
    // MARK: - Actions
    @IBAction private func calendarClicked() {
        if let dateString = dateTextField.text,
           let date = dateFormatter.date(from: dateString),
           dateString.count == 10 {
            datePicker.date = date
        } else {
            datePicker.date = Date()
        }
        datePickerTextField.becomeFirstResponder()
    }
    
    @objc private func dateUpdated() {
        hideKeyboard()
        let dateString = dateFormatter.string(from: datePicker.date)
        dateTextField.text = dateString
        datePickerTextField.text = dateString
        setDate(dateString)
    }
    
    @objc private func hideKeyboard() {
        self.endEditing(true)
    }
}

extension TitledDateTextFieldView: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == dateTextField {
            let newString = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
            let formattedStringDate = formattedStringDate(newString, mask: "XX" + dateSeparator + "XX" + dateSeparator + "XXXX")
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
            result = "0" + result.prefix(1) + "/0" + result.suffix(1)
        }
        if charactersCount == 4, let dateInt = Int(result.suffix(1)), dateInt > 1 {
            result = result.prefix(3) + "0" + String(dateInt)
        }
        if charactersCount == 5, let dateInt = Int(result.suffix(2)), dateInt > 12 {
            result = String(result.prefix(4))
        }
        return result
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Constants
public extension TitledDateTextFieldView {
    enum Constants {
        public static let errorColor: UIColor = UIColor(AppConstants.Colors.persianRed)
        static let selectedSeparatorColor: UIColor = .black
        static let defaultSeparatorColor: UIColor = .black.withAlphaComponent(0.3)
    }
}
