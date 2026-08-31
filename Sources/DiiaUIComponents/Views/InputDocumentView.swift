
import UIKit
import DiiaCommonTypes

public enum InputDocumentState {
    case unfocused, focused, disabled
}

public final class InputDocumentViewModel {
    public let componentId: String
    public let id: String?
    public let inputCode: String?
    public let placeholder: String?
    public let mandatory: Bool?
    public let keyboardType: UIKeyboardType
    public let defaultText: String?
    public var onChangeText: ((String) -> Void)?
    public let onEndEditing: ((String) -> Void)?
    public let rightAction: Bool
    public let fieldState = Observable<InputDocumentState>(value: .unfocused)
    public let minLength: Int?
    public let maxLength: Int?
    
    init(componentId: String,
         id: String? = nil,
         inputCode: String? = nil,
         placeholder: String? = nil,
         mandatory: Bool? = nil,
         defaultText: String? = nil,
         keyboardType: Int = 0,
         onChangeText: ((String) -> Void)? = nil,
         onEndEditing: ((String) -> Void)? = nil,
         rightAction: Bool = true,
         minLength: Int? = nil,
         maxLength: Int? = nil) {
        self.componentId = componentId
        self.id = id
        self.inputCode = inputCode
        self.placeholder = placeholder
        self.mandatory = mandatory
        self.defaultText = defaultText
        self.keyboardType = UIKeyboardType(rawValue: keyboardType) ?? .default
        self.onChangeText = onChangeText
        self.onEndEditing = onEndEditing
        self.rightAction = rightAction
        self.minLength = minLength
        self.maxLength = maxLength
    }
}

/// inputDocumentMlc
public struct InputDocumentMlc: Codable {
    public let componentId: String
    public let inputCode: String?
    public let value: String?
    public let keyboardType: Int
    public let clearAction: Bool
    public let placeholder: String?
    public let minLength: Int?
    public let maxLength: Int?
    
    public init(
        componentId: String,
        inputCode: String?,
        value: String? = nil,
        placeholder: String? = nil,
        keyboardType: Int = 0,
        clearAction: Bool = true,
        minLength: Int? = nil,
        maxLength: Int? = nil) {
            self.componentId = componentId
            self.inputCode = inputCode
            self.value = value
            self.placeholder = placeholder
            self.keyboardType = keyboardType
            self.clearAction = clearAction
            self.minLength = minLength
            self.maxLength = maxLength
        }
}

/// inputDocumentMlc
public final class InputDocumentView: BaseCodeView, DSInputComponentProtocol {
    public let textField = UITextField()
    private let clearSearchBox = BoxView(subview: UIButton().withSize(Constants.clearButtonSize))
    private let textBlock = BoxView(subview: UIStackView.create(.horizontal, spacing: Constants.stackSpacing))
    
    private(set) var viewModel: InputDocumentViewModel?
    
    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        textBlock.backgroundColor = .white
        textBlock.translatesAutoresizingMaskIntoConstraints = false
        textBlock.subview.addArrangedSubviews([textField, clearSearchBox])
        clearSearchBox.withConstraints(insets: .init(vertical: Constants.verticalStackInset))
        textBlock.withConstraints(insets: .init(horizontal: Constants.horizontalTextInset))
        addSubview(textBlock)
        
        textBlock.anchor(top: topAnchor,
                         leading: leadingAnchor,
                         bottom: bottomAnchor,
                         trailing: trailingAnchor)
        
        clearSearchBox.subview.setImage(R.image.clearInput.image, for: .normal)
        clearSearchBox.subview.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.delegate = self
        
        textField.addTarget(self, action: #selector(textFieldDidChangeValue(_:)), for: .editingChanged)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(textFieldDidTapValue))
        tapRecognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapRecognizer)
        setupUI()
        setupAccessibility()
    }
    
    public func setupUI(textFont: UIFont = FontBook.bigText) {
        textField.font = textFont
        textField.tintColor = .black
        textField.autocapitalizationType = .allCharacters
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    public func configure(viewModel: InputDocumentViewModel) {
        self.viewModel = viewModel
        accessibilityIdentifier = viewModel.componentId
        
        textField.placeholder = viewModel.placeholder
        if textField.text == nil || textField.text?.isEmpty == true {
            textField.text = viewModel.defaultText
        }
        textField.keyboardType = viewModel.keyboardType
        
        clearSearchBox.isHidden = !viewModel.rightAction
        
        setupObserver()
        updateInstructionsState()
    }
    
    public func validate() {
        updateInstructionsState()
    }
    
    @objc private func clearText() {
        textField.text = .empty
        textField.sendActions(for: .editingChanged)
        viewModel?.fieldState.value = .focused
    }
    
    @objc private func textFieldDidTapValue() {
        textField.becomeFirstResponder()
    }
    
    @objc private func textFieldDidChangeValue(_ textField: UITextField) {
        let inputText = textField.text ?? ""
        clearSearchBox.isHidden = viewModel?.rightAction == false || inputText.isEmpty
        viewModel?.onChangeText?(inputText)
    }
    
    private func setupObserver() {
        self.viewModel?.fieldState.value = .unfocused
        
        self.viewModel?.fieldState.observe(observer: self) { [weak self] textFieldState in
            guard let self else { return }
            self.textBlock.backgroundColor = .white
            self.textField.textColor = .black
            switch textFieldState {
            case .focused:
                self.textBlock.withBorder(width: 1.0, color: .black, cornerRadius: Constants.inputCornerRadius)
                self.clearSearchBox.isHidden = viewModel?.rightAction == false || textField.text?.isEmpty ?? true
            case .unfocused:
                self.textBlock.withBorder(width: 1.0, color: .statusGray, cornerRadius: Constants.inputCornerRadius)
                self.clearSearchBox.isHidden = true
            case .disabled:
                self.textBlock.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9529411765, blue: 0.968627451, alpha: 1)
                self.textField.textColor = Constants.disableColor
                self.textField.isEnabled = false
            }
        }
    }
    
    private func updateInstructionsState() {
        let inputText = textField.text ?? ""
        self.viewModel?.fieldState.value = inputText.isEmpty ? .unfocused : .focused
    }
    
    private func setupAccessibility() {
        clearSearchBox.isAccessibilityElement = true
        clearSearchBox.accessibilityTraits = .button
        clearSearchBox.accessibilityLabel = R.Strings.general_accessibility_text_field_clear_button.localized()
    }
    
    //MARK: - DSInputComponentProtocol
    public func isValid() -> Bool {
        let inputText = textField.text ?? ""
        guard let viewModel else { return !inputText.isEmpty }
        if let minLength = viewModel.minLength {
            return inputText.count >= minLength
        }
        if let maxLength = viewModel.maxLength {
            return inputText.count == maxLength
        }
        return !inputText.isEmpty
    }
    
    public func inputCode() -> String {
        return viewModel?.inputCode ?? viewModel?.id ?? Constants.inputCode
    }
    
    public func inputData() -> AnyCodable? {
        return .string(textField.text ?? "")
    }
    
    public func setOnChangeHandler(_ handler: @escaping () -> Void) {
        viewModel?.onChangeText = { _ in
            handler()
        }
    }
}

extension InputDocumentView: UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.viewModel?.fieldState.value = .focused
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        updateInstructionsState()
        viewModel?.onEndEditing?(textField.text ?? "")
        self.viewModel?.fieldState.value = .unfocused
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let maxLength = viewModel?.maxLength else { return true }
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= maxLength
    }
}

// MARK: - Constants
extension InputDocumentView {
    private enum Constants {
        static let inputCode = "inputDocumentMlc"
        static let clearButtonSize = CGSize(width: 24, height: 24)
        static let horizontalTextInset: CGFloat = 16
        static let verticalStackInset: CGFloat = 12
        static let inputCornerRadius: CGFloat = 12
        static let stackSpacing: CGFloat = 8
        static let disableColor = UIColor.black.withAlphaComponent(0.3)
    }
}
