
import UIKit
import DiiaCommonTypes

public final class ConstructorModalView: BaseCodeView {
    
    public let topGroupStack: UIStackView = .create()
    public let bodyStack: UIStackView = .create()
    public let bodyScrollView: ExtendedScrollView = .init()
    public let bottomStack: UIStackView = .create()
    public let loadingView = ContentLoadingView()
    
    private var closeButton = ActionButton(type: .icon).withSize(Constants.closeBtnSize)
    private var loadingIndicator = UIProgressView()
    private var loadingLabel = UILabel()
    
    public var bottomGroupBottomConstraint: NSLayoutConstraint?
    private var bottomGroupHeightConstraint: NSLayoutConstraint?
    
    private var customAccessibilityElements: [Any]?
    
    public override func setupSubviews() {
        addSubview(loadingView)
        loadingView.fillSuperview()
        loadingView.setLoadingState(.ready)
        
        bodyScrollView.addSubview(bodyStack)
        addSubviews([topGroupStack, bodyScrollView, bottomStack, bodyScrollView])
        
        bodyScrollView.contentInset = .init(top: Constants.groupPadding, left: .zero, bottom: .zero, right: .zero)
        
        closeButton.contentEdgeInsets = Constants.closeBtnInnerPadding
        closeButton.isHidden = true
        
        topGroupStack.anchor(top: safeAreaLayoutGuide.topAnchor,
                             leading: leadingAnchor,
                             trailing: trailingAnchor,
                             padding: .zero)
        topGroupStack.addArrangedSubview(UIView().withHeight(.zero))
        
        bodyScrollView.anchor(top: topGroupStack.bottomAnchor,
                              leading: leadingAnchor,
                              trailing: trailingAnchor)
        bodyStack.fillSuperview()
        bodyStack.anchor(top: bodyScrollView.topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        bottomStack.anchor(top: bodyScrollView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        
        bottomGroupHeightConstraint = bottomStack.heightAnchor.constraint(equalToConstant: 0)
        bottomGroupBottomConstraint = bottomAnchor.constraint(equalTo: bottomStack.bottomAnchor)
        bottomGroupBottomConstraint?.isActive = true
        
        addSubview(loadingIndicator)
        loadingLabel.setTextWithCurrentAttributes(text: R.Strings.general_loading.localized(),
                                                  font: FontBook.usualFont)
        addSubview(loadingLabel)
        loadingIndicator.isHidden = true
        loadingLabel.isHidden = true
        loadingIndicator.anchor(top: topAnchor,
                                leading: leadingAnchor,
                                trailing: trailingAnchor,
                                padding: .zero)
        
        loadingLabel.anchor(top: loadingIndicator.bottomAnchor,
                            leading: leadingAnchor,
                            padding: UIEdgeInsets(top: Constants.padding,
                                                  left: Constants.padding,
                                                  bottom: .zero,
                                                  right: .zero))
        
        loadingIndicator.progressImage = R.image.loadingBar.image
        
        setupAccessibility()
    }
    
    public func setupTopGroup(views: [UIView]) {
        topGroupStack.safelyRemoveArrangedSubviews()
        if views.isEmpty {
            topGroupStack.addArrangedSubview(UIView().withHeight(.zero))
            bodyScrollView.contentInset.top = Constants.groupPadding
        } else {
            bodyScrollView.contentInset.top = .zero
            
            var topViews = views
            setupCloseButton(views: &topViews, for: topGroupStack)
            
            topGroupStack.addArrangedSubviews(topViews)
        }
    }
    
    public func setupBody(views: [UIView], withCloseButton: Bool = true) {
        bodyStack.safelyRemoveArrangedSubviews()
        var bodyViews = views
        if closeButton.isHidden, withCloseButton, !bodyViews.isEmpty {
            setupCloseButton(views: &bodyViews, for: bodyStack)
        }
        bodyStack.addArrangedSubviews(bodyViews)
    }
    
    public func setupBottomGroup(views: [UIView]) {
        bottomStack.safelyRemoveArrangedSubviews()
        bottomStack.addArrangedSubviews(views)
        
        if views.isEmpty {
            bottomGroupHeightConstraint?.isActive = true
            bottomGroupBottomConstraint?.constant = 0
            let bottomInset = safeAreaInsets.bottom > 0 ? safeAreaInsets.bottom : Constants.groupPadding
            bodyScrollView.contentInset.bottom = bottomInset
        } else {
            bottomGroupHeightConstraint?.isActive = false
            let bottomInset = safeAreaInsets.bottom > 0 ? safeAreaInsets.bottom : Constants.groupPadding
            bottomGroupBottomConstraint?.constant = bottomInset
            bodyScrollView.contentInset.bottom = 0
        }
        bodyScrollView.separatorShouldAlwaysBeVisible = views.isEmpty ? false : nil
    }
    
    private func setupCloseButton(views: inout [UIView], for stackView: UIStackView) {
        closeButton.isHidden = false
        closeButton.backgroundColor = .clear
        let bottomBox = BoxView(subview: closeButton)
            .withConstraints(insets: .init(top: 0, left: 0, bottom: 0, right: Constants.padding))
        let topView = views.removeFirst()
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        let topBlock = UIStackView.create(.horizontal,
                                          views: [topView, spacer, bottomBox],
                                          alignment: .top)
        stackView.addArrangedSubview(topBlock)
    }
    
    public func setupCloseAction(action: Action) {
        closeButton.tintColor = .black
        closeButton.action = action
    }
    
    public func setupLoading(isActive: Bool) {
        loadingIndicator.layer.sublayers?.forEach { $0.removeAllAnimations() }
        loadingIndicator.setProgress(0.0, animated: false)
        loadingIndicator.isHidden = !isActive
        loadingLabel.isHidden = !isActive
        
        if !isActive { return }
        self.loadingIndicator.layoutIfNeeded()
        self.loadingIndicator.setProgress(1.0, animated: false)
        UIView.animate(
            withDuration: Constants.progressAnimationDuration,
            delay: 0,
            options: [.repeat],
            animations: { [unowned self] in self.loadingIndicator.layoutIfNeeded() }
        )
    }
    
    public func updateAccessibilityElements() {
        if customAccessibilityElements != nil {
            accessibilityElements = customAccessibilityElements.flatMap({ $0 })
        }
        
        UIAccessibility.post(notification: .layoutChanged, argument: self.topGroupStack.subviews.first)
    }
    
    // MARK: - Accessibility
    private func setupAccessibility() {
        isAccessibilityElement = false
        
        closeButton.isAccessibilityElement = true
        closeButton.accessibilityTraits = .button
        closeButton.accessibilityLabel = R.Strings.general_close.localized()
        
        let array = [topGroupStack, bodyScrollView, bottomStack]
        customAccessibilityElements = array
        accessibilityElements = array.compactMap({ $0 })
    }
}

private extension ConstructorModalView {
    enum Constants {
        static let padding: CGFloat = 24
        static let groupPadding: CGFloat = 32
        static let progressAnimationDuration: CGFloat = 1.5
        static let closeBtnSize = CGSize(width: 48, height: 48)
        static let closeBtnPadding = UIEdgeInsets(top: 24, left: .zero, bottom: .zero, right: 16)
        static let closeBtnInnerPadding: UIEdgeInsets = .allSides(16)

    }
}
