import UIKit

public class CheckmarkViewModel {
    public let text: String
    public var isChecked: Bool
    public let componentId: String?

    public init(
        text: String,
        isChecked: Bool,
        componentId: String? = nil) {
            self.text = text
            self.isChecked = isChecked
            self.componentId = componentId
    }
}

public class CheckmarkView: BaseCodeView {
    
    // MARK: - Properties
    private let checkmarkImageView = UIImageView()
    private let textLabel = UILabel().withParameters(font: FontBook.usualFont)
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
        addSubview(textLabel)
        
        checkmarkImageView.anchor(top: topAnchor,
                                  leading: leadingAnchor,
                                  bottom: nil,
                                  trailing: nil,
                                  size: Constants.checkMarkSize)
        textLabel.anchor(top: topAnchor,
                         leading: checkmarkImageView.trailingAnchor,
                         bottom: bottomAnchor,
                         trailing: trailingAnchor,
                         padding: .init(top: 0, left: Constants.leftTextPadding, bottom: 0, right: 0))

        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
        
        isChecked = false
        
        setupAccessibility()
    }
    
    // MARK: - Public Methods
    public func configure(text: String,
                          isChecked: Bool,
                          componentId: String? = nil,
                          onChange: ((Bool) -> Void)?) {
        accessibilityIdentifier = componentId
        accessibilityLabel = text
        
        self.isChecked = isChecked
        self.onChange = onChange
        
        if let attributed: NSAttributedString = text.attributed(font: FontBook.usualFont,
                                                                lineHeight: Constants.lineHeight) {
            self.textLabel.attributedText = attributed
        } else {
            self.textLabel.text = text
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

extension CheckmarkView {
    enum Constants {
        static let leftTextPadding: CGFloat = 12
        static let lineHeight: CGFloat = 18
        static let checkMarkSize: CGSize = .init(width: 20, height: 20)
    }
}
