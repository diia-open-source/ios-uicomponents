
import UIKit
import DiiaCommonTypes

public struct DSEmptyStateMlc: Codable {
    public let componentId: String
    public let iconAtm: DSIconModel?
    public let title: String?
    public let text: String?
    public let parameters: [TextParameter]?
    
    public init(componentId: String, iconAtm: DSIconModel?, title: String?, text: String?, parameters: [TextParameter]?) {
        self.componentId = componentId
        self.iconAtm = iconAtm
        self.title = title
        self.text = text
        self.parameters = parameters
    }
}

//ds_code: emptyStateMlc
final public class DSEmptyStateView: BaseCodeView {
    private let mainStack = UIStackView.create(.vertical,spacing: Constants.smallSpacing, alignment: .center)
    private let iconLabelStack = UIStackView.create(.vertical,spacing: Constants.bigSpacing, alignment: .center)
    private let titleLabel = UILabel().withParameters(font: FontBook.mainFont.regular.size(Constants.fontSize), textColor: .black, textAlignment: .center)
    private let textView = UITextView()
    private let iconView = DSIconView().withSize(Constants.iconSize)
    private var urlOpener: URLOpenerProtocol?
    
    public override func setupSubviews() {
        addSubview(mainStack)
        mainStack.fillSuperview(padding: Constants.paddings)
        iconLabelStack.addArrangedSubviews([
            iconView,
            titleLabel
        ])
        mainStack.addArrangedSubviews([
            iconLabelStack,
            textView
        ])
        textView.font = FontBook.usualFont
        textView.configureForParametrizedText()
        textView.delegate = self
        self.layer.cornerRadius = Constants.cornerRadius
        self.withBorder(width: Constants.borderWidth, color: Constants.borderColor)
    }
    
    public func configure(with model: DSEmptyStateMlc, urlOpener: URLOpenerProtocol? = nil) {
        self.accessibilityIdentifier = model.componentId
        self.urlOpener = urlOpener
        
        iconLabelStack.isHidden = model.iconAtm == nil && model.title == nil
        iconView.isHidden = model.iconAtm == nil
        if let iconAtm = model.iconAtm {
            iconView.setIcon(iconAtm)
        }
        
        titleLabel.isHidden = model.title == nil
        titleLabel.text = model.title
        
        textView.isHidden = model.text == nil
        if let text = model.text {
            if let parameters = model.parameters, !parameters.isEmpty {
                textView.attributedText = text.attributedTextWithParameters(parameters: parameters)
            } else {
                textView.text = text
            }
        }
    }
}

extension DSEmptyStateView: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return !(urlOpener?.url(urlString: URL.absoluteString, linkType: nil) ?? false)
    }
}

private extension DSEmptyStateView {
    enum Constants {
        static let smallSpacing: CGFloat = 8
        static let bigSpacing: CGFloat = 16
        static let fontSize: CGFloat = 16
        static let iconSize: CGSize = .init(width: 32, height: 32)
        static let paddings: UIEdgeInsets = .init(top: 24, left: 32, bottom: 24, right: 32)
        static let cornerRadius: CGFloat = 24
        static let borderWidth: CGFloat = 2
        static let borderColor: UIColor = .init("#FFFFFF")
    }
}
