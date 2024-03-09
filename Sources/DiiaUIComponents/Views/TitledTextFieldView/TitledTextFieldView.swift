import UIKit

public struct TitledTextFieldViewModel {
    public let title: String
    public let placeholder: String
    public let attributedPlaceholder: NSMutableAttributedString?
    public let validators: [TextValidationErrorGenerator]
    public let defaultText: String?
    public let instructionsText: String?
    public let keyboardType: UIKeyboardType
    public let onChangeText: ((String) -> Void)?
    public let shouldChangeCharacters: ((String?, NSRange, String) -> Bool)?
    public let onEndEditing: ((String) -> Void)?
    
    public init(title: String,
                placeholder: String,
                attributedPlaceholder: NSMutableAttributedString? = nil,
                validators: [TextValidationErrorGenerator] = [],
                defaultText: String? = nil,
                instructionsText: String? = nil,
                keyboardType: UIKeyboardType = .default,
                onChangeText: ((String) -> Void)? = nil,
                shouldChangeCharacters: ((String?, NSRange, String) -> Bool)? = nil,
                onEndEditing: ((String) -> Void)? = nil
    ) {
        self.title = title
        self.placeholder = placeholder
        self.attributedPlaceholder = attributedPlaceholder
        self.validators = validators
        self.defaultText = defaultText
        self.instructionsText = instructionsText
        self.onChangeText = onChangeText
        self.onEndEditing = onEndEditing
        self.keyboardType = keyboardType
        self.shouldChangeCharacters = shouldChangeCharacters
    }
}

public class TitledTextFieldView: BaseCodeView {
    public let textField = UITextField()
    
    private let titleLabel = UILabel().withParameters(font: FontBook.smallTitle)
    private let separator = UIView().withHeight(2)
    private let errorLabel = UILabel().withParameters(font: FontBook.smallTitle)
    private let instructionsLabel = UILabel().withParameters(font: FontBook.smallTitle)

    private var viewModel: TitledTextFieldViewModel?
    private var separatorColor: UIColor = .statusGray
    
    public override func setupSubviews() {
        backgroundColor = .clear
        addSubview(titleLabel)
        addSubview(textField)
        addSubview(separator)
        addSubview(errorLabel)
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        textField.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 6, left: 0, bottom: 0, right: 0))
        
        let stack = UIStackView.create(views: [separator, errorLabel, instructionsLabel], spacing: 8)
        addSubview(stack)
        stack.anchor(top: textField.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChangeValue(_:)), for: .editingChanged)
        setupUI()
    }
    
    public func setupUI(titleFont: UIFont = FontBook.smallTitle,
                        textFont: UIFont = FontBook.usualFont,
                        errorFont: UIFont = FontBook.smallTitle,
                        errorColor: UIColor = UIColor(AppConstants.Colors.persianRed),
                        instructionColor: UIColor = .black,
                        separatorColor: UIColor = .statusGray) {
        titleLabel.withParameters(font: titleFont)
        errorLabel.withParameters(font: errorFont, textColor: errorColor)
        instructionsLabel.withParameters(font: errorFont, textColor: instructionColor)
        textField.font = textFont
        separator.backgroundColor = separatorColor
        self.separatorColor = separatorColor
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    public func configure(viewModel: TitledTextFieldViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        textField.placeholder = viewModel.placeholder
        if let attributedPlaceholder = viewModel.attributedPlaceholder {
            textField.attributedPlaceholder = attributedPlaceholder
        }
        textField.text = viewModel.defaultText
        textField.keyboardType = viewModel.keyboardType
        instructionsLabel.text = viewModel.instructionsText
        instructionsLabel.isHidden = viewModel.instructionsText?.count ?? 0 == 0
        errorLabel.text = nil
        errorLabel.isHidden = true
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
    
    @objc private func textFieldDidChangeValue(_ textField: UITextField) {
        let inputText = textField.text ?? .empty
        viewModel?.onChangeText?(inputText)
        if !errorLabel.isHidden {
            updateInstructionsState()
        }
    }
    
    private func updateInstructionsState() {
        let inputText = textField.text ?? .empty
        let errorText = error(for: inputText)
        errorLabel.text = errorText
        errorLabel.isHidden = errorText == nil
        if errorText == nil {
            separator.backgroundColor = inputText.isEmpty ? separatorColor : .black
            textField.textColor = .black
        } else {
            separator.backgroundColor = errorLabel.textColor
            textField.textColor = errorLabel.textColor
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
}

extension TitledTextFieldView: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        updateInstructionsState()
        let inputText = textField.text ?? .empty
        viewModel?.onEndEditing?(inputText)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return viewModel?.shouldChangeCharacters?(textField.text, range, string) ?? true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
