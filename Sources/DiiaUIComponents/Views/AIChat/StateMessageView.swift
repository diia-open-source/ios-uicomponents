

import UIKit
import DiiaCommonTypes

public class StateMessageViewModel {
    public let iconName: String
    public let title: String?
    public let descriptionText: String?
    public let componentId: String?
    public let btnTitle: String?
    public let btnAccessibilityHint: String?
    public let parameters: [TextParameter]?
    public var repeatAction: Callback?
    
    public init(iconName: String = "",
                title: String? = nil,
                btnTitle: String? = nil,
                btnAccessibilityHint: String? = nil,
                descriptionText: String? = nil,
                componentId: String? = nil,
                parameters: [TextParameter]? = nil,
                repeatAction: Callback? = nil) {
        self.iconName = iconName
        self.title = title
        self.btnTitle = btnTitle
        self.btnAccessibilityHint = btnAccessibilityHint
        self.descriptionText = descriptionText
        self.parameters = parameters
        self.componentId = componentId
        self.repeatAction = repeatAction
    }
}

/// design_system_code: stateMessageMlc
public class StateMessageView: BaseCodeView {
    // MARK: - UI Elements
    private let imageView = UIImageView().withSize(Constants.imageSize)
    private let titleLabel = UILabel().withParameters(font: FontBook.mainFont.regular.size(16))
    private let descriptionTextView = UITextView()
    private let repeatButton = VerticalRoundButton()
    
    private var urlOpener: URLOpenerProtocol?
    private var viewModel: StateMessageViewModel?
    
    // MARK: - Life Cycle
    public override func setupSubviews() {
        setupView()
        setupButton()
        setupAccessibility()
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: StateMessageViewModel,
                          titleFont: UIFont = FontBook.mainFont.regular.size(16),
                          buttonFont: UIFont = FontBook.mainFont.regular.size(12),
                          urlOpener: URLOpenerProtocol? = nil) {
        accessibilityIdentifier = viewModel.componentId
        
        imageView.image = UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: viewModel.iconName)

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

        repeatButton.isHidden = viewModel.btnTitle == nil || viewModel.repeatAction == nil
        repeatButton.titleLabel?.font = buttonFont
        repeatButton.setTitle(viewModel.btnTitle, for: .normal)
        repeatButton.accessibilityLabel = viewModel.btnAccessibilityHint ?? viewModel.btnTitle
    }
    
    public func configure(btnTitle: String,
                          titleFont: UIFont = FontBook.mainFont.regular.size(16),
                          buttonFont: UIFont = FontBook.mainFont.regular.size(12)) {
        repeatButton.setTitle(btnTitle, for: .normal)
        titleLabel.font = titleFont
        repeatButton.titleLabel?.font = buttonFont
    }
    
    // MARK: - Private Methods
    private func setupView() {
        backgroundColor = UIColor.init(white: 1, alpha: 0.5)
        clipsToBounds = true
        
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = Constants.cornerRadius

        let textStack = UIStackView.create(
            views: [
                titleLabel,
                descriptionTextView
            ],
            spacing: Constants.descriptionSpacing,
            alignment: .center)
        
        let stack = UIStackView.create(
            views: [
                imageView,
                textStack,
                repeatButton
            ],
            spacing: Constants.stackSpacing,
            alignment: .center)

        addSubview(stack)
        stack.fillSuperview(padding: .init(vertical: Constants.verticalPadding))
        stack.setCustomSpacing(Constants.buttonSpacing, after: textStack)
        
        descriptionTextView.configureForParametrizedText()
        descriptionTextView.delegate = self
        
        titleLabel.textAlignment = .center
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
    
    private func setupAccessibility() {
        repeatButton.isAccessibilityElement = true
        repeatButton.accessibilityTraits = .button
    }
    
    // MARK: - Actions
    @objc private func repeatTapped() {
        viewModel?.repeatAction?()
    }
}

extension StateMessageView: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return !(urlOpener?.url(urlString: URL.absoluteString, linkType: nil) ?? false)
    }
}

extension StateMessageView {
    private enum Constants {
        static let buttonInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        static let buttonHeight: CGFloat = 36
        static let buttonBorderWidth: CGFloat = 2
        static let stackSpacing: CGFloat = 16
        static let buttonSpacing: CGFloat = 20
        static let descriptionSpacing: CGFloat = 8
        static let cornerRadius: CGFloat = 16
        static let verticalPadding: CGFloat = 24
        static let imageSize = CGSize(width: 32, height: 32)
    }
}
