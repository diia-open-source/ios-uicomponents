
import UIKit
import DiiaCommonTypes

public class ConstructorModalView: BaseCodeView {
    
    public let topGroupStack: UIStackView = .create(views: [])
    public let bodyStack: UIStackView = .create(views: [])
    public let bodyScrollView: ExtendedScrollView = .init()
    public let bottomStack: UIStackView = .create(views: [])
    public let loadingView = ContentLoadingView()
    
    private var closeButton = ActionButton(type: .icon)
    private var loadingIndicator = UIProgressView()
    private var loadingLabel = UILabel()
    
    public var bottomGroupBottomConstraint: NSLayoutConstraint?
    private var bottomGroupHeightConstraint: NSLayoutConstraint?
    
    public override func setupSubviews() {
        addSubview(loadingView)
        loadingView.fillSuperview()
        loadingView.setLoadingState(.ready)
        
        bodyScrollView.addSubview(bodyStack)
        addSubviews([topGroupStack, bodyScrollView, bottomStack, bodyScrollView, closeButton])
        
        bodyScrollView.contentInset = .init(top: Constants.groupPadding, left: .zero, bottom: .zero, right: .zero)
        
        closeButton.anchor(top: safeAreaLayoutGuide.topAnchor,
                           leading: topGroupStack.trailingAnchor,
                           trailing: trailingAnchor,
                           padding: Constants.closeBtnPadding,
                           size: Constants.closeBtnSize)
        closeButton.contentEdgeInsets = Constants.closeBtnInnerPadding
        topGroupStack.anchor(top: safeAreaLayoutGuide.topAnchor,
                             leading: leadingAnchor,
                             bottom: nil,
                             trailing: nil,
                             padding: .zero)
        topGroupStack.addArrangedSubview(UIView().withHeight(.zero))
        
        bodyScrollView.anchor(top: topGroupStack.bottomAnchor,
                              leading: leadingAnchor,
                              bottom: nil,
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
            topGroupStack.addArrangedSubviews(views)
        }
    }
    
    public func setupBody(views: [UIView], withCloseButton: Bool = true) {
        closeButton.isHidden = !withCloseButton
        bodyStack.safelyRemoveArrangedSubviews()
        bodyStack.addArrangedSubviews(views)
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
    
    // MARK: - Accessibility
    private func setupAccessibility() {
        closeButton.isAccessibilityElement = true
        closeButton.accessibilityTraits = .button
        closeButton.accessibilityLabel = R.Strings.general_close.localized()
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
