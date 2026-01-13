
import UIKit
import DiiaCommonTypes

public final class DSInputNumberLargeViewModel {
    public let id: String
    public let items: [DSInputNumberLargeItemData]
    public let mandatory: Bool?
    public let mandatoryCounter: Int?
    public var number: String = .empty
    public var onChange: Callback?
    public var onReset: Callback?
    
    public init(
        id: String,
        items: [DSInputNumberLargeItemData],
        mandatory: Bool?,
        mandatoryCounter: Int?,
        onChange: Callback? = nil
    ) {
        self.id = id
        self.items = items
        self.mandatory = mandatory
        self.mandatoryCounter = mandatoryCounter
        self.onChange = onChange
    }
    
    public var isValid: Bool {
        guard let requiredCount = mandatoryCounter else {
            return true
        }

        let markedMandatory = items.enumerated().compactMap { index, item in
            item.mandatory == true ? index : nil
        }

        let targetIndexes = markedMandatory.isEmpty
            ? Array(items.indices)
            : markedMandatory
        
        let filledCount = targetIndexes.filter { index in
            guard index < number.count, index < items.count else { return false }
            let char = number[number.index(number.startIndex, offsetBy: index)]
            return char != Character("*")
        }.count

        return filledCount >= requiredCount
    }
    
    public func resetInput() {
        number = String(repeating: Character("*"), count: items.count)
        onReset?()
    }
}

/// design_system_code: inputNumberLargeMlc
public final class DSInputNumberLargeView: BaseCodeView, DSInputComponentProtocol {
    // MARK: - Subviews
    private lazy var numberStackView = UIStackView.create(
        .horizontal,
        spacing: Constants.spacing,
        distribution: .fillEqually,
        in: self)
    
    // MARK: - Properties
    private var viewModel: DSInputNumberLargeViewModel?
    private var number = ""
    
    // MARK: - Init
    public override func setupSubviews() {
        self.backgroundColor = .clear
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: DSInputNumberLargeViewModel) {
        self.viewModel = viewModel
        
        numberStackView.safelyRemoveArrangedSubviews()
        for (index, item) in viewModel.items.enumerated() {
            let textFieldTag = tag(for: index)
            addTextField(with: item, tag: textFieldTag)
            viewModel.number.append(Constants.emptyChar)
        }
       
        if let firstField = viewWithTag(Constants.firstFieldTag) as? UITextField {
            firstField.becomeFirstResponder()
        }
        
        viewModel.onReset = { [weak self] in
            guard let self = self else { return }
            for idx in viewModel.items.indices {
                if let tf = self.viewWithTag(self.tag(for: idx)) as? UITextField {
                    tf.text = ""
                }
            }
        }
    }
    
    // MARK: - Private Methods
    private func addTextField(with model: DSInputNumberLargeItemData, tag: Int) {
        let inputNumberView = DSInputNumberLargeItemView()
        inputNumberView.configure(with: model)
        inputNumberView.textField.tag = tag
        inputNumberView.textField.delegate = self
        inputNumberView.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        if tag == Constants.firstFieldTag {
            inputNumberView.textField.textContentType = .oneTimeCode
            
        }
        
        numberStackView.addArrangedSubview(inputNumberView)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let vm = viewModel else { return }
        let currentTag = textField.tag
        let currentIndex = currentTag - 1
        
        let modelCharIndex = vm.number.index(vm.number.startIndex, offsetBy: currentIndex)
        let previousCharacter = vm.number[modelCharIndex]
        
        let latestInput = String(textField.text?.suffix(1) ?? "")
        textField.text = latestInput
        
        let newCharacter: String = latestInput.isEmpty ? Constants.emptyChar : latestInput
        vm.number.replaceSubrange(modelCharIndex...modelCharIndex, with: newCharacter)
        vm.onChange?()
        
        if latestInput.isEmpty && previousCharacter == Character(Constants.emptyChar) {
            if currentIndex > 0,
               let previousField = viewWithTag(currentTag - 1) as? UITextField {
                previousField.text = .empty
                let prevModelCharIndex = vm.number.index(vm.number.startIndex,
                                                         offsetBy: currentIndex - 1)
                vm.number.replaceSubrange(prevModelCharIndex...prevModelCharIndex,
                                          with: Constants.emptyChar)
                vm.onChange?()
                previousField.becomeFirstResponder()
            }
            return
        }
        
        if let nextField = viewWithTag(currentTag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else if !vm.number.contains(Constants.emptyChar) {
            endEditing(true)
        }
    }
    
    private func tag(for index: Int) -> Int {
        return index + 1
    }
    
    // MARK: - DSInputComponentProtocol
    public func isValid() -> Bool {
        guard let viewModel = self.viewModel else { return true }
        return viewModel.isValid
    }
    
    public func inputCode() -> String {
        return viewModel?.id ?? Constants.inputCode
    }
    
    public func inputData() -> AnyCodable? {
        guard let number = viewModel?.number else { return nil }
        return .string(number)
    }
    
    public func setOnChangeHandler(_ handler: @escaping () -> Void) {
        viewModel?.onChange = handler
    }
}

// MARK: - UITextFieldDelegate
extension DSInputNumberLargeView: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = nil
        
        onMainQueue {
            let newPosition = textField.endOfDocument
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard let inputNumberTextField = textField as? DSInputNumberLargeTextField else { return }
        textField.placeholder = inputNumberTextField.focusPlaceholder
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let inputNumberTextField = textField as? DSInputNumberLargeTextField else { return false }
        return (inputNumberTextField.text?.isEmpty) != nil
    }
    
    /// Specifically for inserting the OTP code
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString: String) -> Bool {
        guard let vm = viewModel else { return false }
        let currentIndex = textField.tag - 1
        let codeLength = vm.items.count
        
        if replacementString.count == codeLength {
            for (position, character) in replacementString.enumerated() {
                if let field = viewWithTag(tag(for: position)) as? UITextField {
                    field.text = String(character)
                    let charModelIndex = vm.number.index(vm.number.startIndex,
                                                         offsetBy: position)
                    vm.number.replaceSubrange(charModelIndex...charModelIndex,
                                              with: String(character))
                }
            }
            vm.onChange?()
            return false
        }
        
        if replacementString.isEmpty && range.length == 1 {
            let existingText = textField.text ?? .empty
            if !existingText.isEmpty {
                textField.text = .empty
                let charModelIndex = vm.number.index(vm.number.startIndex,
                                                     offsetBy: currentIndex)
                vm.number.replaceSubrange(charModelIndex...charModelIndex,
                                          with: Constants.emptyChar)
                vm.onChange?()
            } else if currentIndex > 0,
                    let previousField = viewWithTag(textField.tag - 1) as? UITextField {
                previousField.text = ""
                let previousModelIndex = vm.number.index(vm.number.startIndex,
                                                         offsetBy: currentIndex - 1)
                vm.number.replaceSubrange(previousModelIndex...previousModelIndex,
                                          with: Constants.emptyChar)
                vm.onChange?()
                previousField.becomeFirstResponder()
            }
            return false
        }
        
        if replacementString.count == 1 {
            return true
        }
        
        return false
    }
}

// MARK: - Constants
extension DSInputNumberLargeView {
    private enum Constants {
        static let inputCode = "inputNumberLargeMlc"
        static let cornerRadius: CGFloat = 8
        static let spacing: CGFloat = 8
        static let textFieldPadding = UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
        static let emptyChar: String = "*"
        static let firstFieldTag = 1
    }
}
