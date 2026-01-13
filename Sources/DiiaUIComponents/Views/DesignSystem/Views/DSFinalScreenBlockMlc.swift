import UIKit
import DiiaCommonTypes

/// design_system_code: finalScreenBlockMlc
public struct DSFinalScreenBlockMlc: Codable {
    public let componentId: String
    public let extraLargeIconAtm: DSIconModel?
    public let title: String?
    public let subtitle: String?
    
    public init(componentId: String, extraLargeIconAtm: DSIconModel?, title: String?, subtitle: String?) {
        self.componentId = componentId
        self.extraLargeIconAtm = extraLargeIconAtm
        self.title = title
        self.subtitle = subtitle
    }
}

public final class DSFinalScreenBlockView: BaseCodeView {
    // MARK: - UI Elements
    private let emojiImage = UIImageView()
    private let titleLabel = UILabel().withParameters(font: FontBook.mainFont.regular.size(21))
    private let descriptionTextView = UITextView()
    
    private var urlOpener: URLOpenerProtocol?
    
    // MARK: - Life Cycle
    public override func setupSubviews() {
        setupView()
    }
    
    // MARK: - Public Methods
    public func configure(with model: DSFinalScreenBlockMlc,
                          urlOpener: URLOpenerProtocol? = nil) {
        accessibilityIdentifier = model.componentId
        
        self.urlOpener = urlOpener
        
        titleLabel.isHidden = model.title?.count ?? 0 == 0
        titleLabel.text = model.title
        
        descriptionTextView.text = model.subtitle
        descriptionTextView.isHidden = model.subtitle?.count ?? 0 == 0
        
        emojiImage.image = UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: model.extraLargeIconAtm?.code)
    }
    
    // MARK: - Private Methods
    private func setupView() {
        backgroundColor = .clear
        
        let stack = UIStackView.create(
            views: [
                emojiImage,
                titleLabel,
                descriptionTextView
            ],
            spacing: Constants.stackSpacing,
            alignment: .center)
        
        addSubview(stack)
        stack.fillSuperview()
        
        descriptionTextView.configureForParametrizedText()
        descriptionTextView.delegate = self
        descriptionTextView.font = FontBook.mainFont.regular.size(14)
        titleLabel.textAlignment = .center
        descriptionTextView.textAlignment = .center
        emojiImage.withSize(Constants.imageSize)
    }
}

extension DSFinalScreenBlockView: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return !(urlOpener?.url(urlString: URL.absoluteString, linkType: nil) ?? false)
    }
}

extension DSFinalScreenBlockView {
    private enum Constants {
        static let imageSize = CGSize(width: 56, height: 56)
        static let stackSpacing: CGFloat = 16
    }
}
