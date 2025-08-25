import UIKit
import DiiaCommonTypes

public struct ParameterizedAttentionMessage: Codable {
    public let title: String?
    public let text: String?
    public let icon: String
    public let parameters: [TextParameter]?

    public init(title: String?, text: String?, icon: String, parameters: [TextParameter]?) {
        self.title = title
        self.text = text
        self.icon = icon
        self.parameters = parameters
    }
}

/// design_system_code: attentionMessageMlc
public class ParameterizedAttentionView: BaseCodeView {
    
    private var descriptionTextView: UITextView = UITextView()
    private var titleLabel: UILabel = UILabel().withParameters(font: FontBook.bigText)
    private var emojiLabel: UILabel = UILabel().withParameters(font: FontBook.bigEmoji)
    private var urlOpener: URLOpenerProtocol?
    
    // MARK: - LifeCycle
    public override func setupSubviews() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        let imageView = UIImageView(image: R.image.penaltyGradient.image)
        addSubview(imageView)
        imageView.contentMode = .scaleToFill
        imageView.fillSuperview()
        imageView.layer.cornerRadius = Constants.imageCornerRadius
        imageView.clipsToBounds = true
        
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = Constants.containerCornerRadius
        addSubview(container)
        container.fillSuperview(padding: Constants.containerInsets)
        
        container.addSubview(emojiLabel)
        emojiLabel.anchor(top: container.topAnchor, leading: container.leadingAnchor, bottom: nil, trailing: nil, padding: Constants.emojiInsets)
        emojiLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        emojiLabel.setContentHuggingPriority(.required, for: .horizontal)
        let emojiBottom = emojiLabel.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: Constants.emojiBottomConstraint)
        emojiBottom.priority = .required
        emojiBottom.isActive = true
        
        descriptionTextView.linkTextAttributes = [
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        descriptionTextView.isEditable = false
        descriptionTextView.isSelectable = true
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.isUserInteractionEnabled = true
        descriptionTextView.textContainerInset = .zero
        descriptionTextView.textContainer.lineFragmentPadding = .zero
        descriptionTextView.delegate = self
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionTextView])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 2
        container.addSubview(stackView)
        stackView.anchor(top: container.topAnchor, leading: emojiLabel.trailingAnchor, bottom: nil, trailing: container.trailingAnchor, padding: Constants.stackViewInsets)
        let bottomAnchor = stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -Constants.stackViewInsets.bottom)
        bottomAnchor.priority = .defaultHigh
        bottomAnchor.isActive = true
        
        setupAccessibility()
    }
    
    // MARK: - Public Methods
    public func configure(with attentionMessage: ParameterizedAttentionMessage, urlOpener: URLOpenerProtocol?) {
        self.urlOpener = urlOpener

        titleLabel.setTextWithCurrentAttributes(
            text: attentionMessage.title ?? "",
            lineHeight: Constants.titleLineHeight
        )
        descriptionTextView.attributedText = attentionMessage.text?.attributedTextWithParameters(font: FontBook.usualFont, parameters: attentionMessage.parameters ?? [])
        emojiLabel.text = attentionMessage.icon
        
        titleLabel.isHidden = attentionMessage.title?.count ?? 0 == 0
        descriptionTextView.isHidden = attentionMessage.text?.count ?? 0 == 0
        
        accessibilityLabel = attentionMessage.icon + (attentionMessage.title ?? "") + (attentionMessage.text ?? "")
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    // MARK: - Accessibility
    private func setupAccessibility() {
        isAccessibilityElement = true
        accessibilityTraits = .staticText
    }
}

extension ParameterizedAttentionView: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return !(urlOpener?.url(urlString: URL.absoluteString, linkType: nil) ?? false)
    }
}

private extension ParameterizedAttentionView {
    enum Constants {
        static let imageCornerRadius: CGFloat = 8
        static let containerCornerRadius: CGFloat = 6
        static let containerInsets: UIEdgeInsets = .init(top: 2, left: 2, bottom: 2, right: 2)
        static let emojiSize: CGFloat = 32
        static let emojiInsets: UIEdgeInsets = .init(top: 15, left: 16, bottom: 0, right: 0)
        static let emojiBottomConstraint: CGFloat = -15
        static let horizontalSpacingToText: CGFloat = 78
        static let verticalSpacingToText: CGFloat = 70
        static let verticalStackInset: CGFloat = 2
        static let titleLineHeight: CGFloat = 24
        static let descriptionLineHeight: CGFloat = 18
        static let stackViewInsets: UIEdgeInsets = .init(top: 16, left: 10, bottom: 16, right: 16)
    }
}
