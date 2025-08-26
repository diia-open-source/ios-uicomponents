
import UIKit
import DiiaCommonTypes

public class StubMessageViewModel {
    public let icon: String
    public let title: String?
    public let descriptionText: String?
    public let componentId: String?
    public let btnTitle: String?
    public let parameters: [TextParameter]?
    public var repeatAction: Callback?
    
    public init(icon: String = "",
                title: String? = nil,
                btnTitle: String? = nil,
                descriptionText: String? = nil,
                componentId: String? = nil,
                parameters: [TextParameter]? = nil,
                repeatAction: Callback? = nil) {
        self.icon = icon
        self.title = title
        self.btnTitle = btnTitle
        self.descriptionText = descriptionText
        self.parameters = parameters
        self.componentId = componentId
        self.repeatAction = repeatAction
    }
    
    public init(model: DSStubMessageMlc,
                repeatAction: Callback? = nil) {
        self.icon = model.icon ?? ""
        self.title = model.title
        self.btnTitle = model.btnStrokeAdditionalAtm?.label
        self.descriptionText = model.description
        self.componentId = model.componentId
        self.parameters = model.parameters
        self.repeatAction = repeatAction
    }
}

/// design_system_code: stubMessageMlc
public class StubMessageViewV2: BaseCodeView {
    // MARK: - UI Elements
    private let emojiLabel = UILabel().withParameters(font: FontBook.stubEmoji)
    private let titleLabel = UILabel().withParameters(font: FontBook.emptyStateTitleFont)
    private let descriptionTextView = UITextView()
    private let repeatButton = VerticalRoundButton()
    
    private var urlOpener: URLOpenerProtocol?
    private var viewModel: StubMessageViewModel?
    
    // MARK: - Life Cycle
    public override func setupSubviews() {
        setupView()
        setupButton()
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: StubMessageViewModel,
                          titleFont: UIFont = FontBook.emptyStateTitleFont,
                          emojiFont: UIFont = FontBook.stubEmoji,
                          buttonFont: UIFont = FontBook.usualFont,
                          urlOpener: URLOpenerProtocol? = nil) {
        accessibilityIdentifier = viewModel.componentId
        
        self.urlOpener = urlOpener
        self.viewModel = viewModel
        
        titleLabel.isHidden = viewModel.title?.count ?? 0 == 0
        titleLabel.text = viewModel.title
        titleLabel.font = titleFont
        descriptionTextView.font = FontBook.usualFont

        if let params = viewModel.parameters {
            descriptionTextView.attributedText = viewModel.descriptionText?.attributedTextWithParameters(parameters: params)
        } else {
            descriptionTextView.text = viewModel.descriptionText
        }
       
        descriptionTextView.textAlignment = .center
        descriptionTextView.isHidden = viewModel.descriptionText?.count ?? 0 == 0
        
        emojiLabel.font = emojiFont
        emojiLabel.text = viewModel.icon

        repeatButton.isHidden = viewModel.btnTitle == nil || viewModel.repeatAction == nil
        repeatButton.titleLabel?.font = buttonFont
        repeatButton.setTitle(viewModel.btnTitle, for: .normal)
    }
    
    public func configure(btnTitle: String,
                          titleFont: UIFont = FontBook.emptyStateTitleFont,
                          emojiFont: UIFont = FontBook.stubEmoji,
                          buttonFont: UIFont = FontBook.usualFont) {
        repeatButton.setTitle(btnTitle, for: .normal)
        titleLabel.font = titleFont
        emojiLabel.font = emojiFont
        repeatButton.titleLabel?.font = buttonFont
    }
    
    // MARK: - Private Methods
    private func setupView() {
        backgroundColor = .clear
        
        let textStack = UIStackView.create(
            views: [
                titleLabel,
                descriptionTextView
            ],
            spacing: Constants.descriptionSpacing,
            alignment: .center)
        
        let stack = UIStackView.create(
            views: [
                emojiLabel,
                textStack,
                repeatButton
            ],
            spacing: Constants.stackSpacing,
            alignment: .center)
        
        addSubview(stack)
        stack.fillSuperview()
        stack.setCustomSpacing(Constants.buttonSpacing, after: textStack)
        
        descriptionTextView.configureForParametrizedText()
        descriptionTextView.delegate = self
        
        titleLabel.textAlignment = .center
        emojiLabel.textAlignment = .center
    }
    
    private func setupButton() {
        repeatButton.titleLabel?.font = FontBook.usualFont
        repeatButton.setTitleColor(.black, for: .normal)
        repeatButton.setTitle(R.Strings.general_retry.localized(), for: .normal)
        repeatButton.backgroundColor = .clear
        repeatButton.layer.borderWidth = Constants.buttonBorderWidth
        repeatButton.layer.borderColor = UIColor.black.cgColor
        repeatButton.contentEdgeInsets = Constants.buttonInsets
        repeatButton.addTarget(self, action: #selector(repeatTapped), for: .touchUpInside)
        repeatButton.withHeight(Constants.buttonHeight)
    }
    
    // MARK: - Actions
    @objc private func repeatTapped() {
        viewModel?.repeatAction?()
    }
}

extension StubMessageViewV2: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return !(urlOpener?.url(urlString: URL.absoluteString, linkType: nil) ?? false)
    }
}

extension StubMessageViewV2 {
    private enum Constants {
        static let buttonInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        static let buttonHeight: CGFloat = 36
        static let buttonBorderWidth: CGFloat = 2
        static let stackSpacing: CGFloat = 16
        static let buttonSpacing: CGFloat = 20
        static let descriptionSpacing: CGFloat = 8
    }
}
