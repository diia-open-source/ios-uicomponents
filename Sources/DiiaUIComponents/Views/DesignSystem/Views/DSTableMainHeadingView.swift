
import UIKit
import DiiaCommonTypes

public final class DSTableMainHeadingViewModel {
    public let headingModel: DSTableHeadingItemModel
    public let onClickAction: Callback?

    public init(headingModel: DSTableHeadingItemModel, onClickAction: Callback? = nil) {
        self.headingModel = headingModel
        self.onClickAction = onClickAction
    }
}

/// design_system_code: tableMainHeadingMlc
public final class DSTableMainHeadingView: BaseCodeView {
    // MARK: - Subviews
    private let titleLabel = UILabel().withParameters(font: FontBook.smallHeadingFont)
    private let descriptionTextView = LinkOnlyTextView()

    private lazy var labelsStackView = UIStackView.create(views: [titleLabel, descriptionTextView], spacing: Constants.spacing)

    private let headingButton = ActionButton(type: .icon)

    // MARK: - Properties
    private var viewModel: DSTableMainHeadingViewModel?
    private var urlOpener: URLOpenerProtocol?
    
    // MARK: - Init
    public override func setupSubviews() {
        headingButton.tintColor = .black
        headingButton.isHidden = true
        headingButton.withSize(Constants.buttonSize)
        
        descriptionTextView.configureForParametrizedText(linkTextColor: Constants.valueTextColor)
        descriptionTextView.textAlignment = .left
        descriptionTextView.font = FontBook.usualFont
        descriptionTextView.delegate = self

        UIStackView.create(
            .horizontal,
            views: [labelsStackView, headingButton],
            spacing: Constants.spacing,
            alignment: .top,
            in: self
        )
        
        setupAccessibility()
    }
    
    // MARK: - Private Methods
    private func setupAccessibility() {
        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityTraits = .header
        
        descriptionTextView.isAccessibilityElement = true
        descriptionTextView.accessibilityTraits = .staticText
        
        headingButton.isAccessibilityElement = true
        headingButton.accessibilityTraits = .button
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: DSTableMainHeadingViewModel, urlOpener: URLOpenerProtocol? = nil) {
        self.viewModel = viewModel
        self.urlOpener = urlOpener

        titleLabel.text = viewModel.headingModel.label
        titleLabel.accessibilityLabel = viewModel.headingModel.label

        descriptionTextView.isHidden = viewModel.headingModel.description == nil
        if let description = viewModel.headingModel.description {
            descriptionTextView.attributedText = description.attributedTextWithParameters(
                    font: FontBook.usualFont,
                    textColor: Constants.valueTextColor,
                    parameters: viewModel.headingModel.parameters ?? [])
            descriptionTextView.accessibilityLabel = description
            descriptionTextView.accessibilityValue = .empty
        }

        headingButton.isHidden = viewModel.headingModel.icon?.action == nil
        if let iconModel = viewModel.headingModel.icon, let callback = viewModel.onClickAction {
            let imageProvider = UIComponentsConfiguration.shared.imageProvider
            headingButton.accessibilityLabel = iconModel.accessibilityDescription
            headingButton.action = Action(iconName: imageProvider.imageNameForCode(imageCode: iconModel.code),
                                          callback: callback)
        }
    }
}

extension DSTableMainHeadingView: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return !(urlOpener?.url(urlString: URL.absoluteString, linkType: nil) ?? false)
    }
}

// MARK: - Constants
private extension DSTableMainHeadingView {
    enum Constants {
        static let valueTextColor: UIColor = .black.withAlphaComponent(0.4)
        static let spacing: CGFloat = 8
        static let buttonSize = CGSize(width: 24, height: 24)
    }
}
