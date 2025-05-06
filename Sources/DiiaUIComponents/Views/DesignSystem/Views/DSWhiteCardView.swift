
import UIKit
import Lottie
import DiiaCommonTypes

public class DSWhiteCardViewModel {
    public let image: String?
    public let title: String?
    public let label: String
    public let accessibilityDescription: String?
    public let smallIcon: DSIconModel?
    public let icon: DSIconModel?
    public let largeIcon: DSIconModel?
    public let doubleIcon: DSIconModel?
    public let action: Callback
    
    public init(
        image: String?,
        title: String?,
        label: String,
        accessibilityDescription: String?,
        smallIcon: DSIconModel?,
        icon: DSIconModel?,
        largeIcon: DSIconModel?,
        doubleIcon: DSIconModel?,
        action: @escaping Callback
    ) {
        self.image = image
        self.title = title
        self.label = label
        self.accessibilityDescription = accessibilityDescription
        self.smallIcon = smallIcon
        self.icon = icon
        self.largeIcon = largeIcon
        self.doubleIcon = doubleIcon
        self.action = action
    }
}

/// design_system_code: whiteCardMlc
final public class DSWhiteCardView: BaseCodeView {
    
    // MARK: - Subviews
    private let headerImageView = UIImageView().withHeight(Constants.headerImageHeight)
    private let titleLabel = UILabel().withParameters(font: FontBook.cardsHeadingFont)
    private let detailsLabel = UILabel().withParameters(font: FontBook.usualFont)
    private let doubleIconView = DSIconView().withSize(Constants.doubleImageSize)
    private let singleIconView = DSIconView().withSize(Constants.singleImageSize)
    private let arrowIconView = DSIconView().withSize(Constants.arrowImageSize)
    private let largeIconView = DSIconView().withSize(Constants.largeIconSize)
    
    private lazy var headerImagePlaceholder: LottieAnimationView = {
        let animation = LottieAnimation.named(Constants.animationName)
        let lottieView = LottieAnimationView(animation: animation)
        lottieView.loopMode = .loop
        lottieView.backgroundBehavior = .pauseAndRestore
        return lottieView
    }()
    
    // MARK: - Properties
    private var viewModel: DSWhiteCardViewModel?
    
    // MARK: - Init
    override public func setupSubviews() {
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        headerImageView.addSubview(headerImagePlaceholder)
        headerImagePlaceholder.withSize(Constants.placeholderSize)
        headerImagePlaceholder.centerXAnchor.constraint(equalTo: headerImageView.centerXAnchor).isActive = true
        headerImagePlaceholder.centerYAnchor.constraint(equalTo: headerImageView.centerYAnchor).isActive = true
        
        let bottomStack = UIStackView.create(
            .horizontal,
            views: [doubleIconView, largeIconView, singleIconView, spacer, arrowIconView],
            spacing: Constants.itemsSpacing,
            alignment: .center)
        
        stack([headerImageView, titleLabel, detailsLabel, bottomStack],
              spacing: Constants.contentSpacing,
              padding: Constants.contentInsets)
        
        setupUI()
        headerImagePlaceholder.play()
        addTapGestureRecognizer()
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: DSWhiteCardViewModel) {
        self.viewModel = viewModel
        
        titleLabel.isHidden = viewModel.title == nil
        titleLabel.text = viewModel.title

        detailsLabel.text = viewModel.label
        
        if let accessibilityDescription = viewModel.accessibilityDescription {
            accessibilityLabel = accessibilityDescription
            
            setupAccessibility()
        }
        
        headerImageView.isHidden = viewModel.image == nil
        viewModel.image == nil ? headerImagePlaceholder.stop() : headerImagePlaceholder.play()
        if let imageURL = viewModel.image {
            headerImageView.loadImage(imageURL: imageURL, completion: { [weak self] in
                self?.headerImagePlaceholder.stop()
                self?.headerImagePlaceholder.isHidden = true
            })
        }
        
        doubleIconView.isHidden = viewModel.doubleIcon == nil
        if let doubleIcon = viewModel.doubleIcon {
            doubleIconView.setIcon(doubleIcon)
        }
        
        largeIconView.isHidden = viewModel.largeIcon == nil
        if let largeIcon = viewModel.largeIcon {
            largeIconView.setIcon(largeIcon)
        }
        
        singleIconView.isHidden = viewModel.icon == nil
        if let singleIcon = viewModel.icon {
            singleIconView.setIcon(singleIcon)
        }
        
        arrowIconView.isHidden = viewModel.smallIcon == nil
        if let smallIcon = viewModel.smallIcon {
            arrowIconView.setIcon(smallIcon)
        }
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = Constants.backgroundColor
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true
        
        headerImageView.layer.cornerRadius = Constants.headerImageRadius
        headerImageView.layer.masksToBounds = true
        
        doubleIconView.contentMode = .scaleAspectFill
        largeIconView.contentMode = .scaleAspectFill
    }
    
    private func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    // MARK: - Accessibility
    private func setupAccessibility() {
        titleLabel.isAccessibilityElement = false
        detailsLabel.isAccessibilityElement = false
        
        isAccessibilityElement = true
        accessibilityTraits = .button
    }
    
    // MARK: - Actions
    @objc private func onClick() {
        viewModel?.action()
    }
}

// MARK: - Constants
private extension DSWhiteCardView {
    enum Constants {
        static let backgroundColor: UIColor = .white.withAlphaComponent(0.5)
        
        static let itemsSpacing: CGFloat = 8
        static let contentSpacing: CGFloat = 12
        static let cornerRadius: CGFloat = 16
        static let headerImageRadius: CGFloat = 12
        static let contentInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        static let headerImageHeight: CGFloat = 80
        static let placeholderSize = CGSize(width: 60, height: 60)
        static let doubleImageSize = CGSize(width: 58, height: 32)
        static let singleImageSize = CGSize(width: 32, height: 32)
        static let arrowImageSize = CGSize(width: 24, height: 24)
        static let largeIconSize = CGSize(width: 68, height: 28)
        
        static let animationName = "placeholder_black"
    }
}
