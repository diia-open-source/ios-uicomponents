import UIKit
import DiiaCommonTypes

public class AttentionView: BaseCodeView {
    
    private var descriptionLabel: UILabel = UILabel().withParameters(font: FontBook.usualFont)
    private var titleLabel: UILabel = UILabel().withParameters(font: FontBook.bigText)
    private var emojiLabel: UILabel = UILabel().withParameters(font: FontBook.bigEmoji)
    
    // MARK: - LifeCycle
    public override func setupSubviews() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        let imageView = UIImageView(image: R.image.penaltyGradient.image)
        addSubview(imageView)
        imageView.contentMode = .scaleToFill
        imageView.fillSuperview()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 6
        addSubview(container)
        container.fillSuperview(padding: .init(top: 2, left: 2, bottom: 2, right: 2))
        
        container.addSubview(emojiLabel)
        emojiLabel.anchor(top: container.topAnchor, leading: container.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 15, left: 16, bottom: 0, right: 0))
        emojiLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        emojiLabel.setContentHuggingPriority(.required, for: .horizontal)
        let emojiBottom = emojiLabel.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -15)
        emojiBottom.priority = .required
        emojiBottom.isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 2
        container.addSubview(stackView)
        let anchors = stackView.anchor(top: container.topAnchor, leading: emojiLabel.trailingAnchor, bottom: container.bottomAnchor, trailing: container.trailingAnchor, padding: .init(top: 16, left: 10, bottom: 16, right: 16))
        anchors.bottom?.priority = .defaultHigh
        
        setupAccessibility()
    }
    
    // MARK: - Public Methods
    public func configure(title: String?, description: String?, emoji: String) {
        titleLabel.setTextWithCurrentAttributes(text: title ?? "", lineHeight: Constants.titleLineHeight)
        descriptionLabel.setTextWithCurrentAttributes(text: description ?? "", lineHeight: Constants.descriptionLineHeight)
        emojiLabel.text = emoji
        
        titleLabel.isHidden = title?.count ?? 0 == 0
        descriptionLabel.isHidden = description?.count ?? 0 == 0
        
        accessibilityLabel = emoji + (title ?? "") + (description ?? "")
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    public func configure(with attentionMessage: AttentionMessage) {
        titleLabel.setTextWithCurrentAttributes(
            text: attentionMessage.title ?? "",
            lineHeight: Constants.titleLineHeight
        )
        descriptionLabel.setTextWithCurrentAttributes(
            text: attentionMessage.text ?? "",
            lineHeight: Constants.descriptionLineHeight
        )
        emojiLabel.text = attentionMessage.icon
        
        titleLabel.isHidden = attentionMessage.title?.count ?? 0 == 0
        descriptionLabel.isHidden = attentionMessage.text?.count ?? 0 == 0
        
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

private extension AttentionView {
    enum Constants {
        static let emojiSize: CGFloat = 32
        static let horizontalSpacingToText: CGFloat = 78
        static let verticalSpacingToText: CGFloat = 70
        static let verticalStackInset: CGFloat = 2
        static let titleLineHeight: CGFloat = 24
        static let descriptionLineHeight: CGFloat = 18
    }
}
