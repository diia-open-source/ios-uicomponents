
import UIKit
import Foundation
import DiiaCommonTypes

public struct DSInputPhoneCodeModelV2: Codable {
    public let componentId: String?
    public let label: String
    public let hint: String?
    public let mandatory: Bool?
    public let inputCode: String
    public let inputPhoneMlcV2: DSInputPhoneModel
    public let codeValueId: String?
    public let codeValueIsEditable: Bool?
    public let isDisable: Bool?
    public let codes: [DSPhoneCodeModel]
    
    public init(
        componentId: String?,
        label: String,
        hint: String?,
        mandatory: Bool?,
        inputCode: String,
        inputPhoneMlcV2: DSInputPhoneModel,
        codeValueId: String?,
        codeValueIsEditable: Bool?,
        codes: [DSPhoneCodeModel],
        isDisable: Bool?
    ) {
        self.componentId = componentId
        self.label = label
        self.hint = hint
        self.mandatory = mandatory
        self.inputCode = inputCode
        self.inputPhoneMlcV2 = inputPhoneMlcV2
        self.codeValueId = codeValueId
        self.codeValueIsEditable = codeValueIsEditable
        self.codes = codes
        self.isDisable = isDisable
    }
}

/// design_system_code: inputPhoneCodeOrgV2
public final class InputPhoneCodeViewV2: BaseCodeView, DSInputComponentProtocol {
    
    // MARK: - Subviews
    private let titleLabel = UILabel().withParameters(font: FontBook.statusFont)
    private let phoneCodeSelectorView = PhoneCodeSelectorViewV2().withWidth(Constants.phoneCodeViewWidth)
    private let textField = UITextField()
    private let hintLabel = UILabel().withParameters(font: FontBook.statusFont, textColor: .halfBlack)
    private let errorLabel = UILabel().withParameters(font: FontBook.statusFont, textColor: Constants.errorColor)
    private let clearSearchBox: BoxView<UIButton> = BoxView(subview: UIButton()).withConstraints(size: Constants.clearButtonSize,
                                                                                                 centeredY: true)
    private var textStackBox: BoxView<UIStackView> = BoxView(subview: UIStackView())
    
    // MARK: - Properties
    private var viewModel: DSInputPhoneCodeViewModel?
    
    // MARK: - Init
    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        textField.font = FontBook.bigText
        
        let phoneCodeStack = UIStackView.create(
            .horizontal,
            views: [phoneCodeSelectorView, textField],
            spacing: Constants.phoneCodeSpacing)
        
        let titlePhoneStack = UIStackView.create(
            views: [titleLabel, phoneCodeStack],
            spacing: Constants.stackSpacing)
        
        textStackBox = BoxView(subview: hstack(titlePhoneStack, clearSearchBox,
                                               spacing: Constants.stackSpacing)).withConstraints(insets: Constants.contentPadding)
        textStackBox.backgroundColor = .white
        
        let bottomStack = UIStackView.create(views: [hintLabel, errorLabel],
                                             padding: Constants.bottomPadding)
        stack([textStackBox, bottomStack], spacing: Constants.smallSpacing)
        
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChangeValue(_:)), for: .editingChanged)
        
        clearSearchBox.subview.setImage(R.image.clearInput.image, for: .normal)
        clearSearchBox.subview.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(textFieldDidTapValue))
        tapRecognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapRecognizer)
        
        addSelectorGestureRecognizer()
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: DSInputPhoneCodeViewModel) {
        self.viewModel?.currentPhoneCode.removeObserver(observer: self)
        self.viewModel = viewModel
        
        titleLabel.text = viewModel.label
        hintLabel.isHidden = viewModel.hint == nil

        if let hint = viewModel.hint {
            hintLabel.text = hint
        }
        
        viewModel.currentPhoneCode.observe(observer: self) { [weak self] _ in
            self?.updateView()
        }
        
        self.viewModel?.fieldState.observe(observer: self) { [weak self] textFieldState in
            guard let self = self else { return }
            self.textStackBox.backgroundColor = .white
            self.textField.textColor = .black
            switch textFieldState {
            case .error(let focused):
                self.titleLabel.textColor = Constants.errorColor
                self.textStackBox.withBorder(width: 1.0,
                                             color: Constants.errorColor,
                                             cornerRadius: Constants.cornerRadius)
                self.errorLabel.isHidden = self.errorLabel.text == nil
                self.hintLabel.isHidden = true
                self.clearSearchBox.isHidden = !focused || textField.text?.isEmpty ?? true
            case .focused:
                self.textStackBox.withBorder(width: 1.0,
                                             color: .black,
                                             cornerRadius: Constants.cornerRadius)
                self.titleLabel.textColor = .black
                self.errorLabel.isHidden = true
                self.hintLabel.isHidden = self.viewModel?.hint?.isEmpty == true
                self.clearSearchBox.isHidden = textField.text?.isEmpty ?? true
            case .unfocused:
                self.textStackBox.withBorder(width: 1.0,
                                             color: .statusGray,
                                             cornerRadius: Constants.cornerRadius)
                self.titleLabel.textColor = .black
                self.hintLabel.isHidden = self.viewModel?.hint?.isEmpty == true
                self.clearSearchBox.isHidden = true
            case .disabled:
                self.textStackBox.backgroundColor = Constants.disabledBackgroundColor
                self.titleLabel.textColor = Constants.disableColor
                self.textField.textColor = Constants.disableColor
                self.textField.isEnabled = false
                self.clearSearchBox.isHidden = true
                self.phoneCodeSelectorView.setupUI(textColor: .lightGray, imageColor: .lightGray)
            }
        }
        viewModel.eventHandler(.onComponentConfigured(with: .phoneCodeView(viewModel: viewModel)))
    }
    
    // MARK: - Private Methods
    private func updateView() {
        guard let mainViewModel = viewModel, let currentPhoneCode = mainViewModel.currentPhoneCode.value else { return }
        
        mainViewModel.validators = currentPhoneCode.validation?.map { .init(validationModel: $0) } ?? []
        
        let mask = currentPhoneCode.maskCode?.replacingOccurrences(of: "#", with: "X")
        
        viewModel?.shouldChangeCharacters = TextInputFormatter.phoneFormatter(
            textField: textField,
            mask: mask,
            onChange: { [weak self] text in
                self?.onChange(text: text)
            }
        )

        let value = mainViewModel.value?.formattedPhoneNumber(mask: mask ?? .empty)
        textField.text = value
        textField.keyboardType = .decimalPad
        textField.placeholder = currentPhoneCode.placeholder
        textField.accessibilityIdentifier = viewModel?.inputPhoneComponentId
        
        let selectorViewModel = DSPhoneCodeSelectorViewModel(model: currentPhoneCode,
                                                             isEditable: mainViewModel.codeValueIsEditable)
        phoneCodeSelectorView.configure(with: selectorViewModel)
        
        onEndEditing(text: value ?? .empty)
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
    
    @objc private func clearText() {
        textField.text = .empty
        onChange(text: .empty)
        textField.sendActions(for: .editingChanged)
        viewModel?.fieldState.value = .focused
    }
    
    private func updateInstructionsState() {
        let inputText = textField.text ?? .empty
        let errorText = error(for: inputText)
        errorLabel.text = errorText
        if errorText != nil {
            self.viewModel?.fieldState.value = .error(focused: !inputText.isEmpty)
        } else {
            self.viewModel?.fieldState.value = inputText.isEmpty ? .unfocused : .focused
        }
    }
    
    private func error(for text: String) -> String? {
        guard let viewModel = viewModel,
              let phoneCode = viewModel.currentPhoneCode.value?.value
        else { return nil }
        
        let phone = (phoneCode + text).withoutSpaces
        guard !text.isEmpty else { return nil }
        for validator in viewModel.validators {
            if let error = validator.validationError(text: phone) {
                return error
            }
        }
        return nil
    }
    
    private func addSelectorGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTappedAction))
        phoneCodeSelectorView.addGestureRecognizer(tapGesture)
        phoneCodeSelectorView.isUserInteractionEnabled = true
    }
    
    // MARK: - Actions
    @objc private func onTappedAction() {
        guard let viewModel = viewModel, viewModel.codeValueIsEditable else { return }
        viewModel.eventHandler(.phoneCodeAction(viewModel: viewModel))
    }
    
    private func onChange(text: String) {
        guard let viewModel = viewModel,
              let phoneCode = viewModel.currentPhoneCode.value?.value
        else { return }
        
        viewModel.value = text
        
        let phone = (phoneCode + text).digits
        viewModel.eventHandler(.inputChanged(
            .init(inputCode: viewModel.inputCode, inputData: .string(phone))
        ))
    }
    
    private func onEndEditing(text: String) {
        let errorText = error(for: text)
        errorLabel.text = errorText
        if errorText != nil {
            self.viewModel?.fieldState.value = .error(focused: true)
        } else {
            self.viewModel?.fieldState.value = text.isEmpty ? .unfocused : .focused
        }
    }

    // MARK: - DSInputComponentProtocol
    public func isValid() -> Bool {
        guard let inputText = textField.text?.withoutSpaces else { return false }
        guard viewModel?.mandatory == true else { return error(for: inputText) == nil }
        return !inputText.isEmpty && error(for: inputText) == nil
    }
    
    public func inputCode() -> String {
        return viewModel?.inputCode ?? Constants.inputCode
    }
    
    public func inputData() -> AnyCodable? {
        guard let inputText = textField.text?.withoutSpaces,
              let phoneCode = viewModel?.currentPhoneCode.value?.value,
              !inputText.isEmpty
        else { return nil }
        
        let phone = (phoneCode + inputText).digits
        return .string(phone)
    }
}

extension InputPhoneCodeViewV2: UITextFieldDelegate {
    
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
private extension InputPhoneCodeViewV2 {
    enum Constants {
        static let cornerRadius: CGFloat = 12
        static let phoneCodeViewWidth: CGFloat = 88
        static let phoneCodeSpacing: CGFloat = 12
        static let stackSpacing: CGFloat = 8
        static let smallSpacing: CGFloat = 4
        static let bottomPadding = UIEdgeInsets(top: .zero, left: 16, bottom: .zero, right: 16)
        static let clearButtonSize = CGSize(width: 24, height: 24)
        static let contentPadding = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        static let errorColor = UIColor(AppConstants.Colors.persianRed)
        static let disableColor = UIColor.black.withAlphaComponent(0.3)
        static let disabledBackgroundColor: UIColor = #colorLiteral(red: 0.9411764706, green: 0.9529411765, blue: 0.968627451, alpha: 1)
        static let inputCode = "inputPhoneCodeV2"
    }
}
