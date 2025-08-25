import UIKit
import DiiaCommonTypes

public class TitledMultilineTextView: BaseCodeView, DSInputComponentProtocol {
    
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
        textView.smartQuotesType = .no
        textView.smartDashesType = .no
        textView.smartInsertDeleteType = .no
        textView.delegate = self
        setupUI()
    }
    
    public func setupUI(titleFont: UIFont = FontBook.smallTitle,
                        textFont: UIFont = FontBook.usualFont,
                        errorFont: UIFont = FontBook.smallTitle,
                        errorColor: UIColor = UIColor(AppConstants.Colors.persianRed),
                        instructionColor: UIColor = .black540,
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
                componentId: viewModel.componentId,
                id: viewModel.id,
                inputCode: viewModel.id,
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
    
    private func updateInstructionsState() {
        let inputText = textView.text ?? .empty
        let errorText = error(for: inputText)
        errorLabel.text = errorText
        errorLabel.isHidden = errorText == nil
        
        if errorText == nil {
            separator.backgroundColor = separatorColor
            titleLabel.textColor = .black
        } else {
            separator.backgroundColor = errorLabel.textColor
            titleLabel.textColor = errorLabel.textColor
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
    
    //MARK: - DSInputComponentProtocol
    public func isValid() -> Bool {
        guard let inputText = textView.text else { return false }
        
        if viewModel?.mandatory == true {
            return !inputText.isEmpty && error(for: inputText) == nil
        } else {
            return error(for: inputText) == nil
        }
    }
    
    public func inputCode() -> String {
        return viewModel?.inputCode ?? viewModel?.id ?? viewModel?.componentId ?? Constants.inputCode
    }
    
    public func inputData() -> AnyCodable? {
        guard let inputText = textView.text, !inputText.isEmpty else { return nil }
        return .string(inputText)
    }
    
    public func setOnChangeHandler(_ handler: @escaping () -> Void) {
        viewModel?.onChangeText = { _ in
            handler()
        }
    }
}

extension TitledMultilineTextView: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            titleLabel.textColor = UIColor.black
            errorLabel.isHidden = true
        }
        separator.backgroundColor = .black
    }

    public func textViewDidChange(_ textView: UITextView) {
        let text = textView.text ?? ""
        viewModel?.onChangeText?(text)
        if !errorLabel.isHidden {
            updateInstructionsState()
        }
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        // Add placeholder if field is empty
        if textView.text.isEmpty {
            titleLabel.textColor = .black
            errorLabel.isHidden = true
            separator.backgroundColor = .black
            showTextViewPlaceholder()
        } else {
            updateInstructionsState()
        }
    }

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return viewModel?.shouldChangeCharacters?(textView.text, range, text) ?? true
    }
}

// MARK: - Constants
extension TitledMultilineTextView {
    private enum Constants {
        static let inputCode = "inputTextMultilineMlc"
    }
}
