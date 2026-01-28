
import UIKit
import DiiaCommonTypes
import Lottie

public enum DSInputNumberLoadingIconsState {
    case defaultIcons
    case loading
    case success
}

public struct DSInputNumberMlcModel: Codable {
    public let componentId: String?
    public let inputCode: String?
    public let label: String
    public let placeholder: String?
    public let hint: String?
    public let value: String?
    public let maxValue: Double?
    public let minValue: Double?
    public let mandatory: Bool?
    public let errorMessage: String?
    public let mask: String?
    public let iconRight: DSIconModel?
    
    public init(componentId: String?,
                inputCode: String?,
                label: String,
                placeholder: String?,
                hint: String?,
                value: String?,
                maxValue: Double?,
                minValue: Double?,
                mandatory: Bool?,
                errorMessage: String?,
                mask: String? = nil,
                iconRight: DSIconModel? = nil) {
        self.componentId = componentId
        self.inputCode = inputCode
        self.label = label
        self.placeholder = placeholder
        self.hint = hint
        self.value = value
        self.maxValue = maxValue
        self.minValue = minValue
        self.mandatory = mandatory
        self.errorMessage = errorMessage
        self.mask = mask
        self.iconRight = iconRight
    }
}

// MARK: - ViewModel
public final class DSInputNumberMlcViewModel {
    public let componentId: String?
    public let inputCode: String?
    public let label: String
    public let placeholder: String?
    public let hint: String?
    public let maskCapacity: Int?
    public let mask: String?
    public let value: String?
    public let maxValue: Double?
    public let minValue: Double?
    public let mandatory: Bool?
    public let errorMessage: String?
    public let iconRight: DSIconModel?
    public let fieldState = Observable<TextFieldState>(value: .unfocused)
    public let accessoryState = Observable<DSInputNumberLoadingIconsState>(value: .defaultIcons)
    public var validators: [TextValidationErrorGenerator] = []
    
    public init(
        componentId: String?,
        inputCode: String?,
        label: String,
        placeholder: String?,
        hint: String?,
        mask: String?,
        value: String?,
        maxValue: Double?,
        minValue: Double?,
        mandatory: Bool?,
        errorMessage: String?,
        iconRight: DSIconModel?
    ) {
        self.componentId = componentId
        self.inputCode = inputCode
        self.label = label
        self.placeholder = placeholder
        self.hint = hint
        self.mask = mask
        if let mask, !mask.isEmpty {
            self.maskCapacity = mask.filter { $0 == "#" }.count
        } else {
            self.maskCapacity = nil
        }
        self.value = value
        self.maxValue = maxValue
        self.minValue = minValue
        self.mandatory = mandatory
        self.errorMessage = errorMessage
        self.iconRight = iconRight
        
        if let capacity = self.maskCapacity {
            validators.append(TextValidationErrorGenerator(type: .length(min: capacity, max: capacity), error: errorMessage))
        }
        
        if minValue != nil || maxValue != nil {
            self.validators.append(
                TextValidationErrorGenerator(
                    type: .number(min: minValue, max: maxValue),
                    error: errorMessage))
        }
    }
}

//ds_code: - inputNumberMlc
final class DSInputNumberMlcView: BaseCodeView {
    private let mainStack = UIStackView.create(.vertical, spacing: Constants.smallSpacing)
    private let labelsStack = UIStackView.create(.vertical, spacing: Constants.smallSpacing)
    private let hintErrorStack = UIStackView.create(.vertical)
    private let contentHStack = UIStackView.create(.horizontal, spacing: Constants.defaultSpacing, alignment: .center)
    private let rightIcon = DSIconView()
    private let clearButton = DSIconView()
    private let containerView = UIView()
    private let titleLabel = UILabel().withParameters(font: Constants.titleLabelFont)
    private let textField = UITextField()
    private let hintLabel = UILabel().withParameters(font: Constants.hintLabelFont, textColor: Constants.hintColor)
    private let errorLabel = UILabel().withParameters(font: Constants.errorLabelFont, textColor: Constants.errorColor)
    private var viewModel: DSInputNumberMlcViewModel?
    private var eventHandler: ((ConstructorItemEvent) -> Void)?
    private var lastNotifiedDigits: String?
    private var currentDigits: String?
    
    private lazy var checkInput: LottieAnimationView = {
        let animation = LottieAnimation.named("check_input")
        let lottieView = LottieAnimationView(animation: animation)
        lottieView.loopMode = .playOnce
        lottieView.backgroundBehavior = .pauseAndRestore
        return lottieView
    }()
    
    private lazy var loader: LottieAnimationView = {
        let animation = LottieAnimation.named("black_spinner")
        let lottieView = LottieAnimationView(animation: animation)
        lottieView.loopMode = .loop
        lottieView.backgroundBehavior = .pauseAndRestore
        return lottieView
    }()
    
    // MARK: - Lifecycle
    override func setupSubviews() {
        addSubview(mainStack)
        mainStack.fillSuperview()
        mainStack.addArrangedSubviews([
            containerView,
            hintErrorStack
        ])
        hintErrorStack.withMargins(Constants.errorHintStackInsets)
        containerView.addSubview(contentHStack)
        containerView.backgroundColor = Constants.backgroundColor
        containerView.withBorder(width: Constants.borderWidth, color: Constants.borderEmpty)
        containerView.layer.cornerRadius = Constants.corner
        
        contentHStack.fillSuperview(padding: Constants.insets)
        contentHStack.addArrangedSubviews([
            labelsStack,
            clearButton,
            rightIcon,
            loader,
            checkInput
        ])
        clearButton.withSize(Constants.iconSize)
        rightIcon.withSize(Constants.iconSize)
        loader.withSize(Constants.iconSize)
        checkInput.withSize(Constants.iconSize)
        
        labelsStack.addArrangedSubviews([
            titleLabel,
            textField
        ])
        
        textField.font = Constants.textFieldFont
        textField.keyboardType = .numberPad
        textField.borderStyle = .none
        textField.clearButtonMode = .never
        textField.delegate = self
        
        hintErrorStack.addArrangedSubviews([
            hintLabel,
            errorLabel
        ])
        
        loader.isHidden = true
        checkInput.isHidden = true
    }
    
    //MARK: - Public methods
    public func setEventHandler(_ eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.eventHandler = eventHandler
    }
    
    public func configure(with viewModel: DSInputNumberMlcViewModel) {
        self.viewModel = viewModel
        eventHandler?(.onComponentConfigured(with: .inputNumber(viewModel: viewModel)))
        titleLabel.text = viewModel.label
        hintLabel.text = viewModel.hint
        hintLabel.isHidden = viewModel.hint == nil
        errorLabel.text = nil
        errorLabel.isHidden = true
        
        textField.placeholder = viewModel.placeholder ?? viewModel.mask
        lastNotifiedDigits = nil
        currentDigits = nil
        
        if let value = viewModel.value {
            applyMask(value)
            notifyInputChanged(digits: value)
        } else {
            textField.text = nil
        }
        
        rightIcon.isHidden = viewModel.iconRight == nil
        if let icon = viewModel.iconRight {
            rightIcon.setIcon(icon)
        }
        
        if let iconAction = viewModel.iconRight?.action {
            rightIcon.tapGestureRecognizer { [weak self] in
                self?.eventHandler?(.action(iconAction))
            }
        }
        
        clearButton.setIcon(R.image.clearInput.image ?? UIImage())
        clearButton.tapGestureRecognizer { [weak self] in
            self?.onClearTapped()
        }
        
        viewModel.fieldState.removeObserver(observer: self)
        viewModel.fieldState.observe(observer: self) { [weak self] state in
            self?.updateState(with: state)
        }
        
        viewModel.accessoryState.removeObserver(observer: self)
        viewModel.accessoryState.observe(observer: self) { [weak self] state in
            self?.updateAccessoryState(state)
        }
        
        updateIconsVisibility()
        updateInstructionsState()
    }
    
    //MARK: Private Methdos
    private func updateState(with state: TextFieldState) {
        switch state {
        case .unfocused:
            self.isUserInteractionEnabled = true
            self.containerView.alpha = Constants.defaultAlpha
            self.containerView.layer.borderColor = Constants.borderEmpty.cgColor
            self.containerView.backgroundColor = Constants.backgroundColor
            self.titleLabel.textColor = .black
            self.errorLabel.isHidden = true
            self.hintLabel.isHidden = self.viewModel?.hint?.isEmpty == true
        case .focused:
            self.isUserInteractionEnabled = true
            self.containerView.alpha = Constants.defaultAlpha
            self.containerView.layer.borderColor = Constants.borderFocus.cgColor
            self.containerView.backgroundColor = Constants.backgroundColor
            self.titleLabel.textColor = .black
            self.errorLabel.isHidden = true
            self.hintLabel.isHidden = self.viewModel?.hint?.isEmpty == true
        case .error:
            self.isUserInteractionEnabled = true
            self.containerView.alpha = Constants.defaultAlpha
            self.containerView.layer.borderColor = Constants.errorColor.cgColor
            self.titleLabel.textColor = Constants.errorColor
            self.errorLabel.isHidden = false
            self.hintLabel.isHidden = true
        case .disabled:
            self.isUserInteractionEnabled = false
            self.containerView.layer.borderColor = Constants.borderEmpty.cgColor
            self.containerView.backgroundColor = Constants.disabledBgColor
            self.containerView.alpha = Constants.disabledAlpha
            self.titleLabel.textColor = .black
            self.errorLabel.isHidden = true
            self.hintLabel.isHidden = self.viewModel?.hint?.isEmpty == true
        }
        self.layoutIfNeeded()
    }
    
    private func updateAccessoryState(_ state: DSInputNumberLoadingIconsState) {
        switch state {
        case .defaultIcons:
            stopLoader()
            stopCheck()
            loader.isHidden = true
            checkInput.isHidden = true
            updateIconsVisibility()
        case .loading:
            rightIcon.isHidden = true
            clearButton.isHidden = true
            checkInput.isHidden = true
            loader.isHidden = false
            playLoader()
        case .success:
            rightIcon.isHidden = true
            clearButton.isHidden = true
            loader.isHidden = true
            stopLoader()
            checkInput.isHidden = false
            playCheckOnce()
        }
        layoutIfNeeded()
    }

    private func playLoader() {
        if !loader.isAnimationPlaying {
            loader.play()
        }
    }

    private func stopLoader() {
        loader.stop()
    }

    private func playCheckOnce() {
        checkInput.stop()
        checkInput.currentProgress = 0
        checkInput.play()
    }

    private func stopCheck() {
        checkInput.stop()
    }
    
    @objc private func onClearTapped() {
        applyMask(nil)
        notifyInputChanged(digits: nil)
    }
    
    private func applyMask(_ rawText: String?) {
        let raw = rawText ?? .empty
        var digits = raw.digits

        if let capacity = viewModel?.maskCapacity, digits.count > capacity {
            digits = String(digits.prefix(capacity))
        }

        if let mask = viewModel?.mask, viewModel?.maskCapacity != nil {
            textField.text = digits.isEmpty ? nil : formatUsingMask(mask, digits: digits)
        } else {
            textField.text = digits.isEmpty ? nil : digits
        }
        
        currentDigits = digits.isEmpty ? nil : digits

        updateIconsVisibility()
        updateInstructionsState()
    }

    private func updateIconsVisibility() {
        guard viewModel?.accessoryState.value == .defaultIcons else { return }
        
        let hasText = !(textField.text?.isEmpty ?? false)
        let hasScanner = (viewModel?.iconRight != nil && viewModel?.mask != nil)
        
        if hasScanner {
            rightIcon.isHidden = hasText
            clearButton.isHidden = !hasText
        } else {
            rightIcon.isHidden = true
            clearButton.isHidden = !hasText
        }
    }
    
    private func notifyInputChanged(digits: String?) {
        if digits == lastNotifiedDigits { return }
        lastNotifiedDigits = digits
        
        let inputData: AnyCodable? = digits.map { .string($0) }
        eventHandler?(.inputChanged(.init(
            inputCode: viewModel?.inputCode ?? Constants.inputCode,
            inputData: inputData
        )))
    }
    
    //MARK: - Validation
    private func updateInstructionsState() {
        let digits = currentDigits ?? .empty
        let hasFocus = textField.isFirstResponder
        
        if digits.isEmpty {
            errorLabel.text = nil
            errorLabel.isHidden = true
            viewModel?.fieldState.value = hasFocus ? .focused : .unfocused
            return
        }
        
        if hasFocus, (viewModel?.maskCapacity != nil), !isMaskSatisfied(by: digits) {
            errorLabel.text = nil
            errorLabel.isHidden = true
            viewModel?.fieldState.value = .focused
            return
        }
        
        let errorText = error(for: digits)
        errorLabel.text = errorText
        errorLabel.isHidden = !(errorText != nil)
        
        if errorText != nil {
            viewModel?.fieldState.value = .error(focused: hasFocus)
        } else {
            viewModel?.fieldState.value = hasFocus ? .focused : .unfocused
        }
    }
    
    private func error(for text: String) -> String? {
        guard !text.isEmpty else { return nil }
        for validator in viewModel?.validators ?? [] {
            if let error = validator.validationError(text: text) {
                return error
            }
        }
        return nil
    }
    
    private func formatUsingMask(_ mask: String, digits: String) -> String {
        var result = ""
        var digitIndex = digits.startIndex
        
        for symbol in mask {
            guard digitIndex < digits.endIndex else { break }
            if symbol == "#" {
                result.append(digits[digitIndex])
                digitIndex = digits.index(after: digitIndex)
            } else {
                result.append(symbol)
            }
        }
        return result
    }
    
    private func isMaskSatisfied(by digits: String) -> Bool {
        guard let capacity = viewModel?.maskCapacity else {
            return true
        }
        return digits.count == capacity
    }
}

//MARK: - TextField delegate methods
extension DSInputNumberMlcView: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        updateInstructionsState()
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        updateInstructionsState()
    }
    
    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {

        let currentText = textField.text ?? ""
        guard let replacementRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: replacementRange, with: string)

        applyMask(updatedText)
        notifyInputChanged(digits: currentDigits)

        return false
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - input protocol
extension DSInputNumberMlcView: DSInputComponentProtocol {
    public func isValid() -> Bool {
        let digits = currentDigits ?? ""
        let mandatory = viewModel?.mandatory ?? false
        
        if mandatory && digits.isEmpty {
            return false
        }
        
        if !digits.isEmpty && !isMaskSatisfied(by: digits) {
            return false
        }
        
        if digits.isEmpty {
            return true
        }
        
        return error(for: digits) == nil
    }
    
    public func inputCode() -> String {
        viewModel?.inputCode ?? Constants.inputCode
    }
    
    public func inputData() -> AnyCodable? {
        guard let digits = currentDigits, !digits.isEmpty else { return nil }
        return .string(digits)
    }
}

private extension DSInputNumberMlcView {
    enum Constants {
        static let defaultSpacing: CGFloat = 8
        static let smallSpacing: CGFloat = 4
        static let corner: CGFloat = 12
        static let borderWidth: CGFloat = 1
        static let iconSize: CGSize = .init(width: 22, height: 22)
        
        static let titleLabelFont = FontBook.usualFont.withSize(11)
        static let textFieldFont =  FontBook.usualFont.withSize(14)
        static let hintLabelFont = FontBook.usualFont.withSize(11)
        static let errorLabelFont = FontBook.usualFont.withSize(11)
        
        static let backgroundColor = UIColor.white
        static let disabledBgColor = UIColor("#F0F3F7")
        static let borderEmpty = UIColor("#DBEAEF")
        static let borderFocus = UIColor.black
        
        static let errorColor = UIColor.red
        static let hintColor = UIColor.black.withAlphaComponent(54)
        static let disabledAlpha: CGFloat = 0.3
        static let defaultAlpha: CGFloat = 1
        static let animation: TimeInterval = 0.15
        static let insets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        static let errorHintStackInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        static let inputCode = "inputNumberMlc"
    }
}
