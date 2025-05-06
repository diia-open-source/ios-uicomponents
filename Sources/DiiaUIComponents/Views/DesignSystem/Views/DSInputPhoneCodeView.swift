
import UIKit
import DiiaCommonTypes

public class DSInputPhoneCodeViewModel {
    public let componentId: String?
    public let inputPhoneComponentId: String
    public let label: String
    public let hint: String?
    public let mandatory: Bool?
    public let inputCode: String
    public var value: String?
    public let codeValueIsEditable: Bool
    public let codes: [DSPhoneCodeModel]
    public var validators: [TextValidationErrorGenerator] = []
    public var currentPhoneCode: Observable<DSPhoneCodeModel?> = .init(value: nil)
    
    public var onChangeText: ((String) -> Void)?
    public var shouldChangeCharacters: ((String?, NSRange, String) -> Bool)?
    public var onEndEditing: ((String) -> Void)?
    
    public let eventHandler: (ConstructorItemEvent) -> Void
    public let fieldState = Observable<TextFieldState>(value: .unfocused)
    
    public init(
        data: DSInputPhoneCodeModel,
        eventHandler: @escaping (ConstructorItemEvent) -> Void,
        onChangeText: ((String) -> Void)? = nil,
        shouldChangeCharacters: ((String?, NSRange, String) -> Bool)? = nil,
        onEndEditing: ((String) -> Void)? = nil
    ) {
        self.componentId = data.componentId
        self.inputPhoneComponentId = data.inputPhoneMlc.componentId
        self.label = data.label
        self.hint = data.hint
        self.mandatory = data.mandatory
        self.inputCode = data.inputCode
        self.codeValueIsEditable = data.codeValueIsEditable ?? true
        self.codes = data.codes
        self.value = data.inputPhoneMlc.value
        self.eventHandler = eventHandler
        self.onChangeText = onChangeText
        self.shouldChangeCharacters = shouldChangeCharacters
        self.onEndEditing = onEndEditing
        
        if let codeId = data.codeValueId ?? data.codes.first?.id,
           let currentPhoneCode = data.codes.first(where: { $0.id == codeId }) {
            self.currentPhoneCode.value = currentPhoneCode
            self.validators = currentPhoneCode.validation?.map { .init(validationModel: $0) } ?? []
        }
    }
}

/// design_system_code: inputPhoneCodeOrg
public class DSInputPhoneCodeView: BaseCodeView, DSInputComponentProtocol {
    
    // MARK: - Subviews
    private let titleLabel = UILabel().withParameters(font: FontBook.statusFont)
    private let phoneCodeSelectorView = DSPhoneCodeSelectorView().withWidth(Constants.phoneCodeViewWidth)
    private let textField = UITextField()
    private let separator = UIView().withHeight(Constants.separatorHeight)
    private let hintLabel = UILabel().withParameters(font: FontBook.statusFont, textColor: .halfBlack)
    private let errorLabel = UILabel().withParameters(font: FontBook.statusFont, textColor: Constants.errorColor)
    
    // MARK: - Properties
    private var viewModel: DSInputPhoneCodeViewModel?
    
    // MARK: - Init
    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        textField.font = FontBook.bigText
        
        let phoneCodeSelectorBox = BoxView(subview: phoneCodeSelectorView).withConstraints(insets: Constants.phoneSelectorPadding)
        let textFieldView = UIView()
        textFieldView.addSubview(textField)
        textFieldView.addSubview(separator)
        
        let phoneCodeStack = UIStackView.create(
            .horizontal,
            views: [phoneCodeSelectorBox, textFieldView],
            spacing: Constants.phoneCodeSpacing)
        let phoneCodeStackBox = BoxView(subview: phoneCodeStack).withConstraints(insets: Constants.phoneContainerPadding)
        
        stack([titleLabel, phoneCodeStackBox, hintLabel, errorLabel])
        
        textField.anchor(top: textFieldView.topAnchor,
                         leading: textFieldView.leadingAnchor,
                         bottom: separator.topAnchor,
                         trailing: textFieldView.trailingAnchor)
        separator.anchor(leading: textFieldView.leadingAnchor,
                         bottom: textFieldView.bottomAnchor,
                         trailing: textFieldView.trailingAnchor)
        
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChangeValue(_:)), for: .editingChanged)
        
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
            switch textFieldState {
            case .error:
                self.titleLabel.textColor = Constants.errorColor
                self.phoneCodeSelectorView.setupUI(dividerColor: Constants.errorColor)
                self.separator.backgroundColor = Constants.errorColor
                self.errorLabel.isHidden = self.errorLabel.text == nil
                self.hintLabel.isHidden = true
            case .focused:
                self.phoneCodeSelectorView.setupUI(dividerColor: self.viewModel?.codeValueIsEditable == true ? .black : .lightGray)
                self.separator.backgroundColor = .black
                self.titleLabel.textColor = .black
                self.errorLabel.isHidden = true
                self.hintLabel.isHidden = self.viewModel?.hint?.isEmpty == true
            case .unfocused:
                self.phoneCodeSelectorView.setupUI(dividerColor: .statusGray)
                self.separator.backgroundColor = .statusGray
                self.titleLabel.textColor = .black
                self.hintLabel.isHidden = self.viewModel?.hint?.isEmpty == true
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
        
        textField.text = mainViewModel.value?.formattedPhoneNumber(mask: mask ?? .empty)
        textField.keyboardType = .decimalPad
        textField.placeholder = currentPhoneCode.placeholder
        textField.accessibilityIdentifier = viewModel?.inputPhoneComponentId
        
        let selectorViewModel = DSPhoneCodeSelectorViewModel(model: currentPhoneCode,
                                                             isEditable: mainViewModel.codeValueIsEditable)
        phoneCodeSelectorView.configure(with: selectorViewModel)
        
        onEndEditing(text: .empty)
    }
    
    @objc private func textFieldDidTapValue() {
        textField.becomeFirstResponder()
    }
    
    @objc private func textFieldDidChangeValue(_ textField: UITextField) {
        let inputText = textField.text ?? .empty
        viewModel?.currentPhoneCode.value?.value = inputText
        viewModel?.onChangeText?(inputText)
        if !errorLabel.isHidden {
            updateInstructionsState()
        }
    }
    
    private func updateInstructionsState() {
        let inputText = textField.text ?? .empty
        let errorText = error(for: inputText)
        errorLabel.text = errorText
        if errorText != nil {
            self.viewModel?.fieldState.value = .error
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
            self.viewModel?.fieldState.value = .error
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

extension DSInputPhoneCodeView: UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.viewModel?.fieldState.value = errorLabel.text == nil ? .focused : .error
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        updateInstructionsState()
        viewModel?.onEndEditing?(textField.text ?? .empty)
        self.viewModel?.fieldState.value = errorLabel.text == nil ? .unfocused : .error
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
private extension DSInputPhoneCodeView {
    enum Constants {
        static let phoneCodeViewWidth: CGFloat = 88
        static let phoneCodeSpacing: CGFloat = 12
        static let separatorHeight: CGFloat = 2
        static let contentPadding: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let phoneSelectorPadding: UIEdgeInsets = .init(top: 8, left: .zero, bottom: .zero, right: .zero)
        static let phoneContainerPadding: UIEdgeInsets = .init(top: .zero, left: .zero, bottom: 8, right: .zero)
        static let errorColor = UIColor(AppConstants.Colors.persianRed)
        static let inputCode = "inputPhoneCode"
    }
}
