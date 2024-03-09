import UIKit

public class TitledMultilineTextView: BaseCodeView {
    
    public let textView = UITextView()
    
    private let titleLabel = UILabel().withParameters(font: FontBook.smallTitle)
    private let separator = UIView().withHeight(2)
    private let errorLabel = UILabel().withParameters(font: FontBook.smallTitle)
    private let instructionsLabel = UILabel().withParameters(font: FontBook.smallTitle)

    private var viewModel: TitledTextFieldViewModel?
    private var separatorColor: UIColor = .statusGray
    
    public override func setupSubviews() {
        backgroundColor = .clear
        addSubview(titleLabel)
        addSubview(textView)
        addSubview(separator)
        addSubview(errorLabel)
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        textView.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 6, left: 0, bottom: 0, right: 0))
        
        let stack = UIStackView.create(views: [separator, errorLabel, instructionsLabel], spacing: 8)
        addSubview(stack)
        stack.anchor(top: textView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        
        textView.linkTextAttributes = [
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        textView.isEditable = true
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.isUserInteractionEnabled = true
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = .zero
        textView.autocapitalizationType = .sentences
        textView.autocorrectionType = .default
        textView.delegate = self
        setupUI()
    }
    
    public func setupUI(titleFont: UIFont = FontBook.smallTitle,
                        textFont: UIFont = FontBook.usualFont,
                        errorFont: UIFont = FontBook.smallTitle,
                        errorColor: UIColor = UIColor(AppConstants.Colors.persianRed),
                        instructionColor: UIColor = .black,
                        separatorColor: UIColor = .statusGray) {
        titleLabel.withParameters(font: titleFont)
        errorLabel.withParameters(font: errorFont)
        errorLabel.textColor = errorColor
        instructionsLabel.withParameters(font: errorFont)
        instructionsLabel.textColor = instructionColor
        textView.font = textFont
        separator.backgroundColor = separatorColor
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    public func configure(viewModel: TitledTextFieldViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        showTextViewPlaceholder()
        if let defaultText = viewModel.defaultText {
            textView.textColor = UIColor.black
            textView.text = defaultText
        }
        textView.keyboardType = viewModel.keyboardType
        instructionsLabel.text = viewModel.instructionsText
        instructionsLabel.isHidden = viewModel.instructionsText?.count ?? 0 == 0
        errorLabel.text = nil
        errorLabel.isHidden = true
    }
    
    public func showTextViewPlaceholder() {
        textView.text = viewModel?.placeholder
        textView.textColor = UIColor.lightGray
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
        let inputText = textView.text ?? .empty
        let errorText = error(for: inputText)
        errorLabel.text = errorText
        errorLabel.isHidden = errorText == nil
        
        if errorText == nil {
            separator.backgroundColor = inputText.isEmpty ? separatorColor : .black
            textView.textColor = .black
        } else {
            separator.backgroundColor = errorLabel.textColor
            textView.textColor = errorLabel.textColor
        }
        instructionsLabel.isHidden = !errorLabel.isHidden
            || viewModel?.instructionsText?.count ?? 0 == 0
    }
    
    private func error(for text: String) -> String? {
        for validator in viewModel?.validators ?? [] {
            if let error = validator.validationError(text: text) {
                return error
            }
        }
        return nil
    }
}

extension TitledMultilineTextView: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        // Remove placeholder when started editing
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    public func textViewDidChange(_ textView: UITextView) {
        // Pass text to presenter when text is changed
        let text = textView.text ?? ""
        viewModel?.onChangeText?(text)
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        updateInstructionsState()
        // Add placeholder if field is empty
        if textView.text.isEmpty {
            showTextViewPlaceholder()
        }
    }

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return viewModel?.shouldChangeCharacters?(textView.text, range, text) ?? true
    }
}
