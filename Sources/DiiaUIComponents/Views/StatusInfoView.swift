
import UIKit
import DiiaCommonTypes

public final class StatusInfoView: BaseCodeView {
    
    // MARK: - Outlets
    private let descriptionLabel: UILabel = UILabel()
    private let titleLabel: UILabel = UILabel()
    private let emojiLabel: UILabel = UILabel()
    
    // MARK: - LifeCycle
    
    public override func setupSubviews() {
        backgroundColor = .clear
        
        let container = UIView()
        
        addSubview(container)
        container.fillSuperview(padding: .init(
                                    top: Constants.containerInset,
                                    left: Constants.containerInset,
                                    bottom: Constants.containerInset,
                                    right: Constants.containerInset))
        container.layer.cornerRadius = Constants.cornerRadius
        container.backgroundColor = .white.withAlphaComponent(0.5)
        
        container.addSubview(emojiLabel)
        emojiLabel.anchor(top: container.topAnchor, leading: container.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: Constants.bigSpacing, left: Constants.bigSpacing, bottom: 0, right: 0))
        emojiLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        emojiLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        let stack = UIStackView.create(views: [titleLabel, descriptionLabel], spacing: Constants.standardSpacing)
        container.addSubview(stack)
        stack.anchor(
            top: container.topAnchor,
            leading: emojiLabel.trailingAnchor,
            bottom: container.bottomAnchor,
            trailing: container.trailingAnchor,
            padding: .init(top: Constants.bigSpacing, left: Constants.standardSpacing, bottom: Constants.bigSpacing, right: Constants.bigSpacing))
        
        emojiLabel.withParameters(font: FontBook.smallHeadingFont)
        titleLabel.withParameters(font: FontBook.usualFont)
        descriptionLabel.withParameters(font: FontBook.bigText)
        
        setupAccessibility()
    }
    
    // MARK: - Accessibility
    private func setupAccessibility() {
        isAccessibilityElement = true
        accessibilityTraits = .staticText
    }
    
    // MARK: - Public Methods
    public func configure(message: GeneralStatusMessage) {
        configure(title: message.name, description: message.description, emoji: message.icon)
        
        accessibilityLabel = [message.icon, message.name, message.description].compactMap({ $0 }).joined()
    }
    
    public func configure(message: AttentionMessage) {
        configure(title: message.title, description: message.text, emoji: message.icon)
        
        accessibilityLabel = [message.icon, message.title, message.text].compactMap({ $0 }).joined()
    }
    
    public func configure(title: String?, description: String?, emoji: String?) {
        titleLabel.setTextWithCurrentAttributes(text: title ?? "", lineHeight: Constants.titleLineHeight)
        descriptionLabel.setTextWithCurrentAttributes(text: description ?? "", lineHeight: Constants.descriptionLineHeight)
        emojiLabel.text = emoji
        
        titleLabel.isHidden = title?.count ?? 0 == 0
        descriptionLabel.isHidden = description?.count ?? 0 == 0
        
        accessibilityLabel = [emoji, title, description].compactMap({ $0 }).joined(separator: ",")
    }
    
    public func configureFonts(title: UIFont = FontBook.usualFont, description: UIFont = FontBook.bigText, emoji: UIFont = FontBook.smallHeadingFont) {
        titleLabel.font = title
        descriptionLabel.font = description
        emojiLabel.font = emoji
    }
    
    public func setDescriptionLineHeight(with lineHeight: CGFloat) {
        descriptionLabel.setTextWithCurrentAttributes(
            text: descriptionLabel.text ?? "",
            lineHeightMultiple: lineHeight
        )
    }
}

private extension StatusInfoView {
    enum Constants {
        static let titleLineHeight: CGFloat = 18
        static let descriptionLineHeight: CGFloat = 17
        
        static let cornerRadius: CGFloat = 8
        static let standardSpacing: CGFloat = 8
        static let bigSpacing: CGFloat = 16
        static let containerInset: CGFloat = 2
    }
}
