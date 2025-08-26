
import UIKit
import DiiaCommonTypes

public struct ParameterizedStatusMessage: Codable {
    public let title: String
    public let icon: String
    public let text: String
    public let parameters: [TextParameter]?

    public init(title: String, icon: String, text: String, parameters: [TextParameter]?) {
        self.title = title
        self.icon = icon
        self.text = text
        self.parameters = parameters
    }
}

/// design_system_code: statusMessageMlc
public class ParameterizedStatusInfoView: BaseCodeView {
    
    // MARK: - Views
    private let titleLabel = UILabel().withParameters(font: FontBook.bigText)
    private let descriptionTextView = UITextView()
    private let emojiLabel = UILabel().withParameters(font: FontBook.smallHeadingFont)
    private let containerView = UIView()
    private var urlOpener: URLOpenerProtocol?

    // MARK: - LifeCycle
    public override func setupSubviews() {
        backgroundColor = .clear
        
        containerView.layer.cornerRadius = Constants.cornerRadius
        containerView.backgroundColor = .white.withAlphaComponent(Constants.containerBackgroundAlpha)
        addSubview(containerView)
        containerView.fillSuperview(padding: .init( top: Constants.containerInset, left: Constants.containerInset, bottom: Constants.containerInset, right: Constants.containerInset))
        
        containerView.addSubview(emojiLabel)
        emojiLabel.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: Constants.bigSpacing, left: Constants.bigSpacing, bottom: 0, right: 0))
        emojiLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        emojiLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        let stack = UIStackView.create(views: [titleLabel, descriptionTextView], spacing: Constants.standardSpacing)
        containerView.addSubview(stack)
        stack.anchor(
            top: containerView.topAnchor,
            leading: emojiLabel.trailingAnchor,
            bottom: containerView.bottomAnchor,
            trailing: containerView.trailingAnchor,
            padding: .init(top: Constants.bigSpacing, left: Constants.standardSpacing, bottom: Constants.bigSpacing, right: Constants.bigSpacing)
        )
        
        descriptionTextView.configureForParametrizedText()
        descriptionTextView.delegate = self
        
        setupAccessibility()
    }
    
    // MARK: - Accessibility
    private func setupAccessibility() {
        containerView.isAccessibilityElement = true
        containerView.accessibilityTraits = .staticText
    }
    
    // MARK: - Public Methods
    public func configure(message: ParameterizedStatusMessage, urlOpener: URLOpenerProtocol?) {
        self.urlOpener = urlOpener

        titleLabel.setTextWithCurrentAttributes(
            text: message.title,
            lineHeight: Constants.titleLineHeight
        )
        descriptionTextView.attributedText = message.text.attributedTextWithParameters(font: FontBook.usualFont, parameters: message.parameters ?? [])
        emojiLabel.text = message.icon
        
        titleLabel.isHidden = message.title.isEmpty
        descriptionTextView.isHidden = message.text.isEmpty
        
        containerView.accessibilityLabel = "\(message.icon), \(message.title), \(message.text)"
    }
    
    public func configureFonts(title: UIFont = FontBook.usualFont,
                               description: UIFont = FontBook.bigText,
                               emoji: UIFont = FontBook.smallHeadingFont) {
        titleLabel.font = title
        descriptionTextView.font = description
        emojiLabel.font = emoji
    }
}

extension ParameterizedStatusInfoView: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return !(urlOpener?.url(urlString: URL.absoluteString, linkType: nil) ?? false)
    }
}

private extension ParameterizedStatusInfoView {
    enum Constants {
        static let titleLineHeight: CGFloat = 18
        static let cornerRadius: CGFloat = 8
        static let standardSpacing: CGFloat = 8
        static let bigSpacing: CGFloat = 16
        static let containerInset: CGFloat = 2
        static let containerBackgroundAlpha: CGFloat = 0.5
    }
}
