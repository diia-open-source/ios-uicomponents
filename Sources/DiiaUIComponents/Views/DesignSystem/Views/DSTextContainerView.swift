
import UIKit
import DiiaCommonTypes

public struct DSTextContainerData: Codable {
    public let componentId: String?
    public let text: String?
    public let label: String?
    public let parameters: [TextParameter]?
    
    public init(componentId: String?, text: String?, label: String?, parameters: [TextParameter]? = nil) {
        self.componentId = componentId
        self.text = text
        self.label = label
        self.parameters = parameters
    }
}

/// design_system_code: textLabelContainerMlc
public final class DSTextContainerView: BaseCodeView {
    private let textView = UITextView()
    private let titleLabel = UILabel().withParameters(font: FontBook.detailsTitleFont)
    
    override public func setupSubviews() {
        let stack = UIStackView.create(views: [titleLabel, textView], spacing: 16)
        //TODO: add spacing according to design
        addSubview(stack)
        backgroundColor = .clear
        stack.backgroundColor = .clear
        stack.fillSuperview()
        setupTextView()
    }
    
    // MARK: - Setup
    public func configure(label: String?, text: String?, parameters: [TextParameter] = []) {
        titleLabel.isHidden = label == nil
        if let label = label {
            titleLabel.text = label
        }
        
        textView.isHidden = text == nil
        if let text = text {
            textView.attributedText = text.attributedTextWithParameters(font: FontBook.usualFont, parameters: parameters)
        }
    }
    
    public func configure(data: DSTextContainerData) {
        self.accessibilityIdentifier = data.componentId
        configure(label: data.label, text: data.text, parameters: data.parameters ?? [])
    }
    
    // MARK: - Private methods
    private func setupTextView() {
        textView.linkTextAttributes = [
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.isUserInteractionEnabled = true
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = .zero
        textView.delegate = self
    }
}

extension DSTextContainerView: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return !(UIComponentsConfiguration.shared.urlOpener?.url(urlString: URL.absoluteString, linkType: nil) ?? false)
    }
}
