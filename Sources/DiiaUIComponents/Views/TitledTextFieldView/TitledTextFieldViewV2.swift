
import UIKit
import DiiaCommonTypes

/// design_system_code: inputTextMlcV2
public final class TitledTextFieldViewV2: BaseCodeView, DSInputComponentProtocol {
    
    public let textField = UITextField()
    
    private let titleLabel = UILabel().withParameters(font: FontBook.smallTitle)
    private let errorLabel = UILabel().withParameters(font: FontBook.smallTitle)
    private let instructionsLabel = UILabel().withParameters(font: FontBook.smallTitle, textColor: .gray)
    private let clearSearchBox: BoxView<UIButton> = BoxView(subview: UIButton().withSize(Constants.clearButtonSize))
    private let textBlock: BoxView<UIStackView> = BoxView(subview: UIStackView.create(.horizontal,
                                                                                      spacing: Constants.stackSpacing))
    private let titleTextStack = UIStackView.create(spacing: Constants.textStackSpacing)

    private(set) var viewModel: TitledTextFieldViewModel?
    
    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        textBlock.backgroundColor = .white
        textBlock.translatesAutoresizingMaskIntoConstraints = false
        titleTextStack.addArrangedSubviews([titleLabel, textField])
        textBlock.subview.addArrangedSubviews([titleTextStack, clearSearchBox])
        clearSearchBox.withConstraints(centeredY: true)
        textBlock.withConstraints(insets: Constants.textBlockInset)
        addSubview(textBlock)
        
        textBlock.anchor(top: topAnchor,
                         leading: leadingAnchor,
                         trailing: trailingAnchor,
                         padding: .init(top: Constants.offset, left: .zero, bottom: .zero, right: .zero))
        
        let stack = UIStackView.create(views: [errorLabel, instructionsLabel],
                                       spacing: Constants.stackSpacing)
        addSubview(stack)
        
        stack.anchor(top: textBlock.bottomAnchor,
                     leading: leadingAnchor,
                     bottom: bottomAnchor,
                     trailing: trailingAnchor,
                     padding: Constants.bottomViewPadding)
        
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
    }
    
    public func setupUI(titleFont: UIFont = FontBook.smallTitle,
                        textFont: UIFont = FontBook.usualFont,
                        errorFont: UIFont = FontBook.smallTitle,
                        errorColor: UIColor = UIColor(AppConstants.Colors.persianRed),
                        instructionColor: UIColor = .gray,
                        separatorColor: UIColor = .statusGray) {
        titleLabel.withParameters(font: titleFont)
        errorLabel.withParameters(font: errorFont, textColor: errorColor)
        instructionsLabel.withParameters(font: errorFont, textColor: instructionColor)
        textField.font = textFont
        textField.tintColor = .black
        
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
        textField.keyboardType = viewModel.keyboardType
        instructionsLabel.text = viewModel.instructionsText
        instructionsLabel.isHidden = viewModel.instructionsText?.isEmpty == true
        errorLabel.text = nil
        errorLabel.isHidden = true
        
        setupObserver()
        updateInstructionsState()
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
    
    @objc private func clearText() {
        textField.text = .empty
        textField.sendActions(for: .editingChanged)
        viewModel?.fieldState.value = .focused
    }
    
    @objc private func textFieldDidTapValue() {
        textField.becomeFirstResponder()
    }
    
    @objc private func textFieldDidChangeValue(_ textField: UITextField) {
        let inputText = maskCleanedText()
        clearSearchBox.isHidden = inputText.isEmpty
        viewModel?.onChangeText?(inputText)
        if !errorLabel.isHidden {
            updateInstructionsState()
        }
    }
    
    private func setupObserver() {
        self.viewModel?.fieldState.value = .unfocused
        
        self.viewModel?.fieldState.observe(observer: self) { [weak self] textFieldState in
            guard let self = self else { return }
            self.textBlock.backgroundColor = .white
            self.textField.textColor = .black
            switch textFieldState {
            case .focused:
                self.titleLabel.textColor = .black
                self.textBlock.withBorder(width: 1.0, color: .black, cornerRadius: Constants.inputCornerRadius)
                self.instructionsLabel.isHidden = self.viewModel?.instructionsText?.isEmpty == true
                self.errorLabel.isHidden = true
                self.clearSearchBox.isHidden = textField.text?.isEmpty ?? true
            case .unfocused:
                self.errorLabel.isHidden = self.errorLabel.text == nil
                self.textBlock.withBorder(width: 1.0, color: .statusGray, cornerRadius: Constants.inputCornerRadius)
                self.titleLabel.textColor = .black
                self.instructionsLabel.isHidden = self.viewModel?.instructionsText?.isEmpty == true
                self.errorLabel.isHidden = true
                self.clearSearchBox.isHidden = true
            case .error(let focused):
                let errorColor = errorLabel.textColor
                self.titleLabel.textColor = errorColor
                self.textBlock.withBorder(width: 1.0, color: errorColor ?? .red, cornerRadius: Constants.inputCornerRadius)
                self.errorLabel.isHidden = false
                self.instructionsLabel.isHidden = true
                self.clearSearchBox.isHidden = !focused || textField.text?.isEmpty ?? true
            case .disabled:
                self.textBlock.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9529411765, blue: 0.968627451, alpha: 1)
                self.titleLabel.textColor = Constants.disableColor
                self.textField.textColor = Constants.disableColor
                self.textField.isEnabled = false
                break
            }
        }
    }
    
    private func updateInstructionsState() {
        let inputText = maskCleanedText()
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
    
    private func maskCleanedText() -> String {
        if let text = textField.text, let mask = viewModel?.mask {
            return text.removingMask(mask: mask) ?? text
        }
        return textField.text ?? .empty
    }
    
    //MARK: - DSInputComponentProtocol
    public func isValid() -> Bool {
        let inputText = maskCleanedText()
        
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
        return .string(maskCleanedText())
    }
    
    public func setOnChangeHandler(_ handler: @escaping () -> Void) {
        viewModel?.onChangeText = { _ in
            handler()
        }
    }
}

extension TitledTextFieldViewV2: UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.viewModel?.fieldState.value = errorLabel.text == nil ? .focused : .error(focused: true)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        updateInstructionsState()
        viewModel?.onEndEditing?(maskCleanedText())
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
extension TitledTextFieldViewV2 {
    private enum Constants {
        static let inputCode = "inputTextV2"
        static let clearButtonSize = CGSize(width: 24, height: 24)
        static let textBlockInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        static let inputCornerRadius: CGFloat = 12
        static let offset: CGFloat = 8
        static let stackSpacing: CGFloat = 8
        static let textStackSpacing: CGFloat = 4
        static let disableColor = UIColor.black.withAlphaComponent(0.3)
        static let bottomViewPadding = UIEdgeInsets(top: 4, left: 16, bottom: .zero, right: 16)
    }
}
