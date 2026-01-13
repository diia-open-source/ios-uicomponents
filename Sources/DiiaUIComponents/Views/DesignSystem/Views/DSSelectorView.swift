
import UIKit
import DiiaCommonTypes

public final class DSSelectorViewModel {
    public let inputCode: String
    public var state: Observable<DropContentState>
    public let title: String
    public let mandatory: Bool?
    public let placeholder: String
    public let hint: String?
    public let searchList: [DSListWidgetItemsContainer]
    public var selectedCode: String?
    public var onClick: Callback?
    public var componentId: String?
    
    public init(
        inputCode: String,
        state: DropContentState,
        title: String,
        mandatory: Bool? = nil,
        placeholder: String,
        hint: String? = nil,
        searchList: [DSListWidgetItemsContainer],
        selectedCode: String? = nil,
        componentId: String? = nil,
        onChange: Callback? = nil
    ) {
        self.inputCode = inputCode
        self.state = .init(value: state)
        self.title = title
        self.mandatory = mandatory
        self.placeholder = placeholder
        self.hint = hint
        self.searchList = searchList
        self.selectedCode = selectedCode
        self.componentId = componentId
        self.onClick = onChange
    }
}

/// design_system_code: selectorOrg
public final class DSSelectorView: BaseCodeView, DSInputComponentProtocol {
    private let titleLabel = UILabel().withParameters(font: FontBook.statusFont)
    private let textLabel = UILabel().withParameters(font: FontBook.bigText)
    private let dividerLine = DSDividerLineView()
    private let hintLabel = UILabel().withParameters(font: FontBook.statusFont)
    
    private var viewModel: DSSelectorViewModel?
    
    // MARK: - Init
    public override func setupSubviews() {
        let arrowIconView: UIImageView = .init().withSize(Constants.arrowImageSize)
        arrowIconView.image = R.image.rightArrow.image
        
        let valueHStack = UIStackView.create(
            .horizontal,
            views: [textLabel, arrowIconView],
            spacing: Constants.horizontalSpacing,
            alignment: .center)
        
        stack([titleLabel, valueHStack, dividerLine, hintLabel],
              spacing: Constants.verticalSpacing)
        
        initialSetup()
        setupGestureRecognizer()
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: DSSelectorViewModel) {
        self.viewModel?.state.removeObserver(observer: self)
        self.viewModel = viewModel
        
        self.accessibilityIdentifier = viewModel.componentId
        titleLabel.text = viewModel.title
        hintLabel.isHidden = viewModel.hint == nil
        if let hint = viewModel.hint {
            hintLabel.text = hint
        }
        
        viewModel.state.observe(observer: self) { [weak self] state in
            self?.setState(state)
        }
        
        setupAccessibility()
    }
    
    // MARK: - Private Methods
    private func initialSetup() {
        dividerLine.backgroundColor = Constants.inactiveColor
    }
    
    private func setState(_ state: DropContentState) {
        guard let viewModel = viewModel else { return }
        switch state {
        case .disabled:
            self.alpha = Constants.inactiveAlpha
            isUserInteractionEnabled = false
        case .enabled:
            textLabel.text = viewModel.placeholder
            textLabel.accessibilityLabel = viewModel.placeholder
            textLabel.textColor = Constants.inactiveColor
            titleLabel.textColor = .black
            dividerLine.backgroundColor = Constants.inactiveColor
            isUserInteractionEnabled = true
            alpha = Constants.activeAlpha
        case .selected(let text):
            textLabel.text = text
            textLabel.accessibilityLabel = text
            textLabel.textColor = .black
            titleLabel.textColor = .black
            dividerLine.backgroundColor = .black
            isUserInteractionEnabled = true
            alpha = Constants.activeAlpha
        case .single(let text):
            textLabel.text = text
            textLabel.accessibilityLabel = text
            alpha = Constants.inactiveAlpha
            isUserInteractionEnabled = false
        default:
            break
        }
    }
    
    private func setupGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        tap.cancelsTouchesInView = false
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
    }
    
    // MARK: - Accessibility
    private func setupAccessibility() {
        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityTraits = .staticText
        titleLabel.accessibilityLabel = viewModel?.title
        
        textLabel.isAccessibilityElement = true
        textLabel.accessibilityTraits = .button
    }
    
    // MARK: - Action
    @objc private func onClick() {
        viewModel?.onClick?()
    }
    
    // MARK: - DSInputComponentProtocol
    public func isValid() -> Bool {
        return viewModel?.selectedCode != nil
    }
    
    public func inputCode() -> String {
        return viewModel?.inputCode ?? Constants.inputCode
    }
    
    public func inputData() -> AnyCodable? {
        guard let data = viewModel?.selectedCode else { return nil }
        return .string(data)
    }
    
    public func setOnChangeHandler(_ handler: @escaping Callback) {
        // TODO: - Whether there's need?
    }
}

// MARK: - Constants
extension DSSelectorView {
    private enum Constants {
        static let verticalSpacing: CGFloat = 8
        static let horizontalSpacing: CGFloat = 12
        static let arrowImageSize = CGSize(width: 8, height: 8)
        
        static let inactiveColor: UIColor = .black.withAlphaComponent(0.3)
        static let inactiveAlpha: CGFloat = 0.3
        static let activeAlpha: CGFloat = 1.0
        
        static let inputCode = "selector"
    }
}
