
import UIKit
import DiiaCommonTypes

public struct TopNavigationBigViewModel {
    public let componentId: String?
    public let title: String
    public let details: String?
    public let backAction: Callback?
    public let action: Action?
    
    public init(
        title: String,
        details: String? = nil,
        componentId: String? = nil,
        backAction: Callback? = nil,
        action: Action? = nil
    ) {
        self.title = title
        self.details = details
        self.componentId = componentId
        self.backAction = backAction
        self.action = action
    }
}

/// design_system_code: titleGroupMlc
public final class TopNavigationBigView: BaseCodeView {
    private let backButtonContainer = BoxView(subview: UIView()).withConstraints(insets: Constants.boxInsets)
    private let backButton = ActionButton()
    private let progressView = BaseProgressView()
    
    private let titleLabel = UILabel().withParameters(font: FontBook.largeFont)
    private let detailsLabel = UILabel().withParameters(
        font: FontBook.usualFont,
        textColor: Constants.blackAlpha,
        numberOfLines: 1
    )
    private let actionButton = ActionButton()
    
    // MARK: - Life Cycle
    public override func setupSubviews() {
        setupUI()
        
        backButtonContainer.addSubview(backButton)
        backButton.anchor(
            top: backButtonContainer.subview.topAnchor,
            leading: backButtonContainer.subview.leadingAnchor,
            bottom: backButtonContainer.subview.bottomAnchor,
            trailing: nil,
            size: Constants.buttonSize)
        
        let contentStackView = UIStackView.create(
            .horizontal,
            views: [
                UIStackView.create(
                    views: [titleLabel, detailsLabel],
                    spacing: Constants.textsSpacing
                ),
                actionButton
            ],
            spacing: Constants.horizontalSpacing,
            alignment: .top
        )
        
        UIStackView.create(
            views: [
                UIStackView.create(
                    views: [
                        backButtonContainer,
                        BoxView(subview: contentStackView).withConstraints(insets: Constants.boxInsets)
                    ]
                ),
                progressView
            ],
            spacing: Constants.contentSpacing,
            in: self,
            padding: Constants.stackInsets
        )
        
        setupAccessibility()
    }
    
    // MARK: - Public Methods
    public func configure(viewModel: TopNavigationBigViewModel) {
        accessibilityIdentifier = viewModel.componentId
        titleLabel.text = viewModel.title
        if let backAction = viewModel.backAction {
            backButton.action = .init(title: nil, image: R.image.menu_back.image, callback: backAction)
        }
        backButtonContainer.isHidden = viewModel.backAction == nil
        detailsLabel.text = viewModel.details
        detailsLabel.isHidden = viewModel.details == nil
        actionButton.isHidden = viewModel.action == nil
        if let action = viewModel.action {
            actionButton.action = action
        }
        
        actionButton.accessibilityLabel = viewModel.action?.accessibilityDescription
    }
    
    public func setLoadingState(_ state: LoadingState) {
        progressView.setLoading(isActive: state == .loading)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .clear
        
        backButton.iconRenderingMode = .alwaysTemplate
        backButton.imageEdgeInsets = Constants.backImageInset
        backButton.tintColor = .black
        
        actionButton.withSize(Constants.buttonSize)
        actionButton.iconRenderingMode = .alwaysOriginal
        actionButton.imageEdgeInsets = Constants.imageInset
    
        progressView.isHidden = true
    }

    private func setupAccessibility() {
        backButtonContainer.isAccessibilityElement = false
        backButton.isAccessibilityElement = true
        backButton.accessibilityLabel = R.Strings.general_accessibility_back_button_hint.localized()
        
        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityTraits = .header
        
        actionButton.isAccessibilityElement = true
        actionButton.accessibilityTraits = .button
    }
}

private extension TopNavigationBigView {
    enum Constants {
        static let stackInsets = UIEdgeInsets(top: 32, left: 0, bottom: 16, right: 0)
        static let boxInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        static let imageInset = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        static let backImageInset = UIEdgeInsets(top: 0, left: 4, bottom: 16, right: 12)
        static let progressViewInsets = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        
        static let contentSpacing: CGFloat = 16
        static let horizontalSpacing: CGFloat = 4
        static let textsSpacing: CGFloat = 8
        static let buttonSize: CGSize = .init(width: 44, height: 44)
        
        static let blackAlpha: UIColor = .black.withAlphaComponent(0.6)
    }
}
