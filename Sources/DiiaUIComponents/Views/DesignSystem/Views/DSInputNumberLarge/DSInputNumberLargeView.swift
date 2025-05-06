
import UIKit
import DiiaCommonTypes

public class DSInputNumberLargeViewModel {
    public let id: String
    public let items: [DSInputNumberLargeItemData]
    public let mandatory: Bool?
    public var number: String = .empty
    public var onChange: Callback?
    
    public init(
        id: String,
        items: [DSInputNumberLargeItemData],
        mandatory: Bool?,
        onChange: Callback? = nil
    ) {
        self.id = id
        self.items = items
        self.mandatory = mandatory
        self.onChange = onChange
    }
    
    var isValid: Bool {
        if let mandatory, mandatory {
            return number
                .filter { $0 != "*" }
                .count >= 1
        } else {
            return true
        }
    }
}

/// design_system_code: inputNumberLargeMlc
public class DSInputNumberLargeView: BaseCodeView, DSInputComponentProtocol {
    // MARK: - Subviews
    private lazy var numberStackView = UIStackView.create(
        .horizontal,
        views: [],
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
        guard let viewModel = viewModel else { return }
            
        let number = String(textField.text?.suffix(1) ?? "")
        textField.text = number
        
        let nextTag = number.isEmpty ? textField.tag - 1 : textField.tag + 1
        (viewWithTag(nextTag) ?? textField).becomeFirstResponder()
        
        let index = viewModel.number.index(viewModel.number.startIndex, offsetBy: textField.tag - 1)
        viewModel.number.replaceSubrange(index...index, with: number.isEmpty ? Constants.emptyChar : number)
        viewModel.onChange?()
    }
    
    private func tag(for index: Int) -> Int {
        return index + 1
    }
    
    // MARK: - DSInputComponentProtocol
    public func isValid() -> Bool {
        return viewModel?.isValid == true
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
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string.count == viewModel?.items.count else { return true }
        for (index, number) in string.enumerated() {
            guard let textField = viewWithTag(tag(for: index)) as? UITextField else { continue }
            textField.text = "\(number)"
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
