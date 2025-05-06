
import UIKit
import Lottie
import DiiaCommonTypes

/// design_system_code: imageCardMlc
final public class DSImageCardView: BaseCodeView {
    private let backgroundImageView = UIImageView()
    private let detailsLabel = UILabel().withParameters(font: FontBook.bigText, textColor: .white)
    private let arrowIconView = UIImageView()
    
    private lazy var imagePlaceholder: LottieAnimationView = {
        let animation = LottieAnimation.named(Constants.animationName)
        let lottieView = LottieAnimationView(animation: animation)
        lottieView.loopMode = .loop
        lottieView.backgroundBehavior = .pauseAndRestore
        return lottieView
    }()
    
    // MARK: - Properties
    private var touchAction: Callback?
    
    // MARK: - Life cycle
    override public func setupSubviews() {
        let bottomViewContainer = UIView()
        bottomViewContainer.backgroundColor = .halfBlack
        bottomViewContainer.hstack(
            detailsLabel, arrowIconView,
            alignment: .center,
            padding: Constants.bottomViewInsets)
        
        addSubview(backgroundImageView)
        backgroundImageView.addSubview(bottomViewContainer)
        backgroundImageView.addSubview(imagePlaceholder)
        
        self.withHeight(Constants.viewHeight)
        arrowIconView.withSize(Constants.iconSize)
        backgroundImageView.fillSuperview()
        
        imagePlaceholder.withSize(Constants.placeholderSize)
        imagePlaceholder.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imagePlaceholder.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        bottomViewContainer.anchor(
            leading: backgroundImageView.leadingAnchor,
            bottom: backgroundImageView.bottomAnchor,
            trailing: backgroundImageView.trailingAnchor)
        
        setupUI()
        setupAccessibility()
        addTapGestureRecognizer()
        imagePlaceholder.play()
    }
    
    // MARK: - Public Methods
    public func configure(with model: DSImageCardModel, touchAction: Callback?) {
        self.accessibilityIdentifier = model.componentId

        if let imageText = model.imageAltText {
            backgroundImageView.accessibilityLabel = imageText
            setupAccessibilityContainer()
        }
        
        self.touchAction = touchAction
        
        detailsLabel.text = model.label
        detailsLabel.accessibilityLabel = model.label
        
        arrowIconView.image = UIComponentsConfiguration.shared.imageProvider?.imageForCode(imageCode: model.iconRight)
        backgroundImageView.loadImage(imageURL: model.image, completion: { [weak self] in
            self?.imagePlaceholder.stop()
            self?.imagePlaceholder.isHidden = true
        })
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = Constants.backgroundColor
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
    }
    
    private func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    // MARK: - Accessibility
    private func setupAccessibility() {
        detailsLabel.isAccessibilityElement = true
        detailsLabel.accessibilityTraits = .button
    }
    
    private func setupAccessibilityContainer() {
        self.isAccessibilityElement = false
        
        backgroundImageView.isAccessibilityElement = true
        backgroundImageView.accessibilityTraits = .image
        
        self.accessibilityElements = [backgroundImageView, detailsLabel]
    }
    
    // MARK: - Actions
    @objc private func onClick() {
        touchAction?()
    }
}

private extension DSImageCardView {
    enum Constants {
        static let backgroundColor = UIColor("#1E1E1E")
        static let viewHeight: CGFloat = 200
        static let spacing: CGFloat = 8
        static let cornerRadius: CGFloat = 16
        static let bottomViewInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let iconSize = CGSize(width: 24, height: 24)
        static let placeholderSize = CGSize(width: 60, height: 60)
        static let animationName = "placeholder_white"
    }
}
