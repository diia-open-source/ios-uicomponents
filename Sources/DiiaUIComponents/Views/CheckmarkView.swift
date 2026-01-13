
import UIKit
import DiiaCommonTypes

public final class CheckmarkViewModel {
    public let text: String
    public var isChecked: Bool
    public let componentId: String?
    public let parameters: [TextParameter]?

    public init(
        text: String,
        isChecked: Bool,
        componentId: String? = nil,
        parameters: [TextParameter]? = nil) {
            self.text = text
            self.isChecked = isChecked
            self.componentId = componentId
            self.parameters = parameters
    }
}

public final class CheckmarkView: BaseCodeView {
    // MARK: - Properties
    private let checkmarkImageView = UIImageView()
    private let textView = UITextView()
    private var isActive = true
    private var onChange: ((Bool) -> Void)?
    
    private var isChecked = false {
        didSet {
            let image = isChecked ? R.image.checkbox_enabled.image : R.image.checkbox_disabled.image
            checkmarkImageView.image = image
            accessibilityTraits = isChecked ? [.button, .selected] : [.button]
            onChange?(isChecked)
        }
    }
    
    // MARK: - LifeCycle
    public override func setupSubviews() {
        addSubview(checkmarkImageView)
        checkmarkImageView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            size: Constants.checkMarkSize
        )

        addSubview(textView)
        textView.anchor(
            top: topAnchor,
            leading: checkmarkImageView.trailingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(left: Constants.leftTextPadding)
        )

        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true

        isChecked = false

        textView.delegate = self
        textView.configureForParametrizedText()

        setupAccessibility()
    }
    
    // MARK: - Public Methods
    public func configure(text: String,
                          isChecked: Bool,
                          componentId: String? = nil,
                          parameters: [TextParameter]? = nil,
                          onChange: ((Bool) -> Void)?) {
        accessibilityIdentifier = componentId
        accessibilityLabel = text
        
        self.isChecked = isChecked
        self.onChange = onChange

        if let attributed = text.attributedTextWithParameters(
                font: FontBook.usualFont,
                lineHeight: Constants.lineHeight,
                parameters: parameters
        ) {
            self.textView.attributedText = attributed
        } else {
            self.textView.text = text
        }
    }
    
    public func setIsActive(isActive: Bool) {
        self.isActive = isActive
    }
    
    public func setSelected(_ state: Bool) {
        guard isActive else { return }
        isChecked = state
    }
    
    // MARK: - Private Methods
    @objc private func onTap() {
        guard isActive else { return }
        isChecked.toggle()
    }
    
    // MARK: - Accessibility
    private func setupAccessibility() {
        isAccessibilityElement = true
    }
}

// MARK: - UITextViewDelegate
extension CheckmarkView: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return !(UIComponentsConfiguration.shared.urlOpener?.url(urlString: URL.absoluteString, linkType: nil) ?? false)
    }
}

extension CheckmarkView {
    enum Constants {
        static let leftTextPadding: CGFloat = 12
        static let lineHeight: CGFloat = 18
        static let checkMarkSize: CGSize = .init(width: 20, height: 20)
    }
}
