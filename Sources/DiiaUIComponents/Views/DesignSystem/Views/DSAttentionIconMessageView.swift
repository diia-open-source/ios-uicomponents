
import UIKit
import DiiaCommonTypes

/// design_system_code: attentionIconMessageMlc, attentionMessageGtMlc
final public class DSAttentionIconMessageView: BaseCodeView {
    private let mainHStack = UIStackView.create(.vertical, spacing: Constants.spacing, alignment: .leading)
    private let iconImage = UIImageView()
    private let textView = UITextView()
    private var urlOpener: URLOpenerProtocol?
    private var isExpanded: Bool = false
    private let expandButtonTitle = UILabel().withParameters(font: FontBook.usualFont)
    private let expandIcon = UIImageView()
    private let expandButtonStack = UIStackView.create(.horizontal, spacing: Constants.spacing, alignment: .leading)
    private var expandModel: DSAttentionIconMessageMlcExpanded?
    private let textLabel = UILabel().withParameters(font: FontBook.usualFont,
                                                              lineBreakMode: .byTruncatingTail)
    
    private var eventHandler: ((ConstructorItemEvent) -> Void)?
    
    public override func setupSubviews() {
        super.setupSubviews()
        layer.cornerRadius = Constants.cornerRadius
        addSubview(mainHStack)
        addSubview(iconImage)
        
        iconImage.withSize(Constants.imageSize)
        expandIcon.withSize(Constants.expandIconSize)
        
        iconImage.anchor(top: topAnchor, leading: leadingAnchor, padding: Constants.iconPaddings)
        mainHStack.anchor(top: topAnchor,
                          leading: iconImage.trailingAnchor,
                          bottom: bottomAnchor,
                          trailing: trailingAnchor,
                          padding: Constants.mainStackPadding)
        
        mainHStack.addArrangedSubviews([textLabel, textView, expandButtonStack])
        expandButtonStack.addArrangedSubviews([expandButtonTitle, expandIcon])
        
        textView.linkTextAttributes = [
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        textView.font = FontBook.usualFont
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.isUserInteractionEnabled = true
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = .zero
        textView.delegate = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapped))
        expandButtonStack.addGestureRecognizer(gesture)
    }
    
    public func configure(with model: DSAttentionIconMessageMlc, urlOpener: URLOpenerProtocol? = nil) {
        self.urlOpener = urlOpener
        let imageProvider = UIComponentsConfiguration.shared.imageProvider
        iconImage.image = imageProvider?.imageForCode(imageCode: model.smallIconAtm.code)
        
        self.expandModel = model.expanded
        expandButtonStack.isHidden = model.expanded == nil
        
        if let expanded = model.expanded {
            self.isExpanded = expanded.isExpanded ?? false
            textLabel.isHidden = false
            textLabel.text = model.text
            textView.isHidden = true
            setState(isExpanded, animated: false)
        } else {
            textLabel.isHidden = true
            textView.isHidden = false
            textView.attributedText = model.text.attributedTextWithParameters(font: FontBook.usualFont, parameters: model.parameters ?? [])
        }
        
        backgroundColor = UIColor(model.backgroundMode.color)
    }
    
    public func setEventHandler(_ eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.eventHandler = eventHandler
    }
    
    @objc private func onTapped() {
        isExpanded.toggle()
        setState(isExpanded, animated: true)
    }
    
    private func setState(_ isExpanded: Bool, animated: Bool) {
        guard let model = expandModel else { return }
        self.expandButtonTitle.text = isExpanded ? model.collapsedText : model.expandedText
        self.expandIcon.image = isExpanded ? R.image.arrowUp.image : R.image.arrowDown.image
        let updateContent = { [weak self] in
            self?.textLabel.alpha = 0.0
            self?.textLabel.numberOfLines = isExpanded ? 0 : Constants.textNumberOfLines
            self?.layoutIfNeeded()
            self?.textLabel.alpha = 1.0
            self?.eventHandler?(.componentSizeDidChange)
        }
        if animated {
            UIView.animate(withDuration: Constants.animationDuration, animations: updateContent)
        } else {
            updateContent()
        }
    }
}

extension DSAttentionIconMessageView: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return !(urlOpener?.url(urlString: URL.absoluteString, linkType: nil) ?? false)
    }
}

extension DSAttentionIconMessageView {
    enum Constants {
        static let mainStackPadding = UIEdgeInsets(top: 16, left: 8, bottom: 18, right: 16)
        static let iconPaddings = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 0)
        static let padding: CGFloat = 16
        static let spacing: CGFloat = 8
        static let lineHeight: CGFloat = 18
        static let cornerRadius: CGFloat = 16
        static let imageSize = CGSize(width: 24, height: 24)
        static let expandIconSize = CGSize(width: 16, height: 16)
        static let animationDuration: TimeInterval = 0.3
        static let textNumberOfLines: Int = 3
    }
}
