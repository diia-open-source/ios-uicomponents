
import UIKit
import DiiaCommonTypes

public enum TextFieldState {
    case unfocused, focused, error(focused: Bool), disabled
}

public class TitledTextFieldViewModel {
    public let componentId: String?
    public let id: String?
    public let inputCode: String?
    public let title: String
    public let placeholder: String
    public let attributedPlaceholder: NSMutableAttributedString?
    public let blocker: Bool?
    public let mandatory: Bool?
    public let validators: [TextValidationErrorGenerator]
    public let mask: String?
    public let defaultText: String?
    public let instructionsText: String?
    public let keyboardType: UIKeyboardType
    public var onChangeText: ((String) -> Void)?
    public var shouldChangeCharacters: ((String?, NSRange, String) -> Bool)?
    public let onEndEditing: ((String) -> Void)?
    public let rightAction: Action?
    public let fieldState = Observable<TextFieldState>(value: .unfocused)
    
    public init(componentId: String? = nil,
                id: String? = nil,
                inputCode: String? = nil,
                title: String,
                placeholder: String,
                attributedPlaceholder: NSMutableAttributedString? = nil,
                validators: [TextValidationErrorGenerator] = [],
                mask: String? = nil,
                blocker: Bool? = false,
                mandatory: Bool? = false,
                defaultText: String? = nil,
                instructionsText: String? = nil,
                keyboardType: UIKeyboardType = .default,
                onChangeText: ((String) -> Void)? = nil,
                shouldChangeCharacters: ((String?, NSRange, String) -> Bool)? = nil,
                onEndEditing: ((String) -> Void)? = nil,
                rightAction: Action? = nil
    ) {
        self.componentId = componentId
        self.id = id
        self.inputCode = inputCode
        self.title = title
        self.placeholder = placeholder
        self.attributedPlaceholder = attributedPlaceholder
        self.validators = validators
        self.mask = mask
        self.blocker = blocker
        self.mandatory = mandatory
        self.defaultText = defaultText
        self.instructionsText = instructionsText
        self.onChangeText = onChangeText
        self.onEndEditing = onEndEditing
        self.keyboardType = keyboardType
        self.shouldChangeCharacters = shouldChangeCharacters
        self.rightAction = rightAction
    }
}

/// design_system_code: inputTextMlc
public class TitledTextFieldView: BaseCodeView, DSInputComponentProtocol {
    public let textField = UITextField()
    
    private let textStack = UIStackView()
    private let titleLabel = UILabel().withParameters(font: FontBook.smallTitle)
    private let separator = UIView().withHeight(Constants.separatorHeight)
    private let errorLabel = UILabel().withParameters(font: FontBook.smallTitle)
    private let instructionsLabel = UILabel().withParameters(font: FontBook.smallTitle, textColor: .black540)
    private let rightButton = ActionButton(type: .icon)
    
    private(set) var viewModel: TitledTextFieldViewModel?
    private var separatorColor: UIColor = .statusGray
    
    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        addSubview(titleLabel)
        addSubview(textStack)
        titleLabel.anchor(top: topAnchor,
                          leading: leadingAnchor,
                          bottom: nil,
                          trailing: trailingAnchor)
        textStack.anchor(top: titleLabel.bottomAnchor,
                         leading: leadingAnchor,
                         trailing: trailingAnchor,
                         padding: .init(top: Constants.offset, left: .zero, bottom: .zero, right: .zero))
        
        textStack.addArrangedSubviews([textField, rightButton])
        textStack.alignment = .center
        rightButton.withSize(Constants.rightButtonSize)
        rightButton.isHidden = true
        rightButton.tintColor = .black
        
        let stack = UIStackView.create(views: [separator, errorLabel, instructionsLabel],
                                       spacing: Constants.stackSpacing)
        addSubview(stack)
        stack.anchor(top: textStack.bottomAnchor,
                     leading: leadingAnchor,
                     bottom: bottomAnchor,
                     trailing: trailingAnchor,
                     padding: .init(top: Constants.offset, left: .zero, bottom: .zero, right: .zero))
        
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChangeValue(_:)), for: .editingChanged)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(textFieldDidTapValue))
        tapRecognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapRecognizer)
        setupUI()
    }
    
    public func setupUI(titleFont: UIFont = FontBook.smallTitle,
                        textFont: UIFont = FontBook.usualFont,
                        errorFont: UIFont = FontBook.smallTitle,
                        errorColor: UIColor = UIColor(AppConstants.Colors.persianRed),
                        instructionColor: UIColor = .black540,
                        separatorColor: UIColor = .statusGray) {
        titleLabel.withParameters(font: titleFont)
        errorLabel.withParameters(font: errorFont, textColor: errorColor)
        instructionsLabel.withParameters(font: errorFont, textColor: instructionColor)
        textField.font = textFont
        textField.tintColor = .black
        separator.backgroundColor = separatorColor
        self.separatorColor = separatorColor
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    public func configure(viewModel: TitledTextFieldViewModel) {
        self.viewModel = viewModel
        accessibilityIdentifier = viewModel.componentId
        
        titleLabel.text = viewModel.title
        textField.placeholder = viewModel.placeholder
        if let attributedPlaceholder = viewModel.attributedPlaceholder {
            textField.attributedPlaceholder = attributedPlaceholder
        }
        if textField.text == nil || textField.text?.isEmpty == true {
            textField.text = viewModel.defaultText
        }
        rightButton.isHidden = viewModel.rightAction == nil
        if let rightAction = viewModel.rightAction {
            rightButton.action = rightAction
        }
        textField.keyboardType = viewModel.keyboardType
        instructionsLabel.text = viewModel.instructionsText
        instructionsLabel.isHidden = viewModel.instructionsText?.isEmpty == true
        errorLabel.text = nil
        errorLabel.isHidden = true
        updateInstructionsState()
        
        self.viewModel?.fieldState.observe(observer: self) { [weak self] textFieldState in
            guard let self = self else { return }
            switch textFieldState {
            case .focused:
                self.separator.backgroundColor = .black
                self.titleLabel.textColor = .black
                self.instructionsLabel.isHidden = self.viewModel?.instructionsText?.isEmpty == true
                self.errorLabel.isHidden = true
            case .unfocused:
                self.errorLabel.isHidden = self.errorLabel.text == nil
                self.separator.backgroundColor = .statusGray
                self.titleLabel.textColor = .black
                self.instructionsLabel.isHidden = self.viewModel?.instructionsText?.isEmpty == true
                self.errorLabel.isHidden = true
            case .error:
                let errorColor = errorLabel.textColor
                self.titleLabel.textColor = errorColor
                self.separator.backgroundColor = errorColor
                self.errorLabel.isHidden = false
                self.instructionsLabel.isHidden = true
            default: break
            }
        }
    }
    
    public func validate() {
        updateInstructionsState()
    }
    
    public func updateValidators(validators: [TextValidationErrorGenerator], forceUpdate: Bool = false) {
        guard let viewModel = viewModel else {
            return
        }
        configure(
            viewModel: TitledTextFieldViewModel(
                title: viewModel.title,
                placeholder: viewModel.placeholder,
                validators: validators,
                mask: viewModel.mask,
                defaultText: viewModel.defaultText,
                instructionsText: viewModel.instructionsText,
                keyboardType: viewModel.keyboardType,
                onChangeText: viewModel.onChangeText,
                shouldChangeCharacters: viewModel.shouldChangeCharacters,
                onEndEditing: viewModel.onEndEditing)
        )
        if forceUpdate {
            updateInstructionsState()
        }
    }
    
    
    @objc private func textFieldDidTapValue() {
        textField.becomeFirstResponder()
    }
    
    @objc private func textFieldDidChangeValue(_ textField: UITextField) {
        let inputText = textField.text ?? .empty
        viewModel?.onChangeText?(inputText)
        if !errorLabel.isHidden {
            updateInstructionsState()
        }
    }
    
    private func updateInstructionsState() {
        var inputText = textField.text ?? .empty
        if let mask = viewModel?.mask {
            inputText = inputText.removingMask(mask: mask) ?? inputText
        }
        let errorText = error(for: inputText)
        errorLabel.text = errorText
        if errorText != nil {
            self.viewModel?.fieldState.value = .error(focused: !inputText.isEmpty)
        } else {
            self.viewModel?.fieldState.value = inputText.isEmpty ? .unfocused : .focused
        }
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
    
    //MARK: - DSInputComponentProtocol
    public func isValid() -> Bool {
        guard let inputText = textField.text else { return false }
        
        if viewModel?.mandatory == true {
            return !inputText.isEmpty && error(for: inputText) == nil
        } else {
            return error(for: inputText) == nil
        }
    }
    
    public func inputCode() -> String {
        return viewModel?.inputCode ?? viewModel?.id ?? Constants.inputCode
    }
    
    public func inputData() -> AnyCodable? {
        guard let inputText = textField.text, !inputText.isEmpty else { return nil }
        return .string(inputText)
    }
    
    public func setOnChangeHandler(_ handler: @escaping () -> Void) {
        viewModel?.onChangeText = { _ in
            handler()
        }
    }
}

extension TitledTextFieldView: UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.viewModel?.fieldState.value = errorLabel.text == nil ? .focused : .error(focused: true)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        updateInstructionsState()
        viewModel?.onEndEditing?(textField.text ?? .empty)
        self.viewModel?.fieldState.value = errorLabel.text == nil ? .unfocused : .error(focused: false)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return viewModel?.shouldChangeCharacters?(textField.text, range, string) ?? true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Constants
extension TitledTextFieldView {
    private enum Constants {
        static let inputCode = "inputText"
        static let offset: CGFloat = 8
        static let stackSpacing: CGFloat = 8
        static let separatorHeight: CGFloat = 2
        static let rightButtonSize = CGSize(width: 16, height: 16)
    }
}
