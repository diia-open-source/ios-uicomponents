
import UIKit
import DiiaCommonTypes

public final class StartServiceView: UIView {
    // MARK: - Outlets
    @IBOutlet private weak var greetingsLabel: UILabel!
    @IBOutlet private weak var attentionView: ParameterizedAttentionView!
    @IBOutlet private weak var statusView: StatusInfoView!
    @IBOutlet private weak var infoTextView: UITextView!

    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib(bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fromNib(bundle: Bundle.module)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK: - Setup
    public func configure(greetings: String, info: String?, parameters: [TextParameter] = []) {
        greetingsLabel.text = greetings
        infoTextView.attributedText = info?.attributedTextWithParameters(font: FontBook.usualFont, parameters: parameters)
    }
    
    public func configureAttention(attention: ParameterizedAttentionMessage?) {
        attentionView.isHidden = attention == nil
        guard let attention = attention else { return }
        attentionView.configure(with: attention, urlOpener: UIComponentsConfiguration.shared.urlOpener)
    }
    
    public func configureStatus(message: GeneralStatusMessage?) {
        statusView.isHidden = message == nil
        guard let message = message else { return }
        statusView.configure(message: message)
    }
}

// MARK: - UI Configuration
private extension StartServiceView {
    func setup() {
        greetingsLabel.font = FontBook.detailsTitleFont
        infoTextView.linkTextAttributes = [
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        infoTextView.isEditable = false
        infoTextView.isSelectable = true
        infoTextView.isScrollEnabled = false
        infoTextView.backgroundColor = .clear
        infoTextView.isUserInteractionEnabled = true
        infoTextView.textContainerInset = .zero
        infoTextView.textContainer.lineFragmentPadding = .zero
        infoTextView.delegate = self
        
        attentionView.isHidden = true
        statusView.isHidden = true
    }
}

extension StartServiceView: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return !(UIComponentsConfiguration.shared.urlOpener?.url(urlString: URL.absoluteString, linkType: nil) ?? false)
    }
}

private extension StartServiceView {
    enum Constants {
        static let labelLineHeight: CGFloat = 1.11
    }
}
