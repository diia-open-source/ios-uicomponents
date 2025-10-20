
import UIKit

public class ConstructorScreenView: BaseCodeView {
    
    public let backgroundImageView = UIImageView()
    public let loadingView = ContentLoadingView()
    public let topGroupStack: UIStackView = .create()
    public let bodyStack: UIStackView = .create()
    public let bodyScrollView: ExtendedScrollView = .init()
    public let bottomStack: UIStackView = .create()
    
    public var bottomGroupBottomConstraint: NSLayoutConstraint?
    private var bottomGroupHeightConstraint: NSLayoutConstraint?
    private var stackHeightConstraint: NSLayoutConstraint?

    private var customAccessibilityElements: [Any]?

    override public func setupSubviews() {
        addSubview(backgroundImageView)
        backgroundImageView.fillSuperview()
        addSubview(loadingView)
        loadingView.fillSuperview()
        loadingView.setLoadingState(.ready)
        addSubview(topGroupStack)
        addSubview(bodyScrollView)
        bodyScrollView.addSubview(bodyStack)
        addSubview(bottomStack)
        
        topGroupStack.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        bodyScrollView.anchor(top: topGroupStack.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        bodyStack.fillSuperview()
        bodyStack.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        bottomStack.anchor(top: bodyScrollView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        
        bottomGroupHeightConstraint = bottomStack.heightAnchor.constraint(equalToConstant: 0)
        bottomGroupBottomConstraint = bottomAnchor.constraint(equalTo: bottomStack.bottomAnchor, constant: 0)
        bottomGroupBottomConstraint?.isActive = true
        
        // TODO: Fix for bottom inset
        stackHeightConstraint = bodyStack.heightAnchor.constraint(equalTo: bodyScrollView.heightAnchor, multiplier: 1, constant: -safeAreaInsets.bottom)
        stackHeightConstraint?.priority = .defaultLow
        stackHeightConstraint?.isActive = false
    }
    
    public func setupTopGroup(views: [UIView]) {
        topGroupStack.safelyRemoveArrangedSubviews()
        topGroupStack.addArrangedSubviews(views)
    }
    
    public func setupBody(views: [UIView]) {
        bodyStack.safelyRemoveArrangedSubviews()
        bodyStack.addArrangedSubviews(views)
        stackHeightConstraint?.isActive = false
    }
    
    public func setupCenteredBody(views: [UIView]) {
        bodyStack.safelyRemoveArrangedSubviews()
        let startView = UIView()
        let endView = UIView()
        let finalViews: [UIView] = [startView] + views + [endView]
        
        bodyStack.addArrangedSubviews(finalViews)
        startView.heightAnchor.constraint(equalTo: endView.heightAnchor, multiplier: 1, constant: -safeAreaInsets.bottom).isActive = true
        stackHeightConstraint?.isActive = true
    }
    
    public func setupBottomGroup(views: [UIView]) {
        bottomStack.safelyRemoveArrangedSubviews()
        bottomStack.addArrangedSubviews(views)
        
        if views.isEmpty {
            bottomGroupHeightConstraint?.isActive = true
            bottomGroupBottomConstraint?.constant = 0
            let bottomInset = safeAreaInsets.bottom > 0 ? safeAreaInsets.bottom : Constants.bottomGroupBottomPadding
            bodyScrollView.contentInset.bottom = bottomInset
        } else {
            bottomGroupHeightConstraint?.isActive = false
            let bottomInset = safeAreaInsets.bottom > 0 ? safeAreaInsets.bottom : Constants.bottomGroupBottomPadding
            bottomGroupBottomConstraint?.constant = bottomInset
            bodyScrollView.contentInset.bottom = 0
        }
        bodyScrollView.separatorShouldAlwaysBeVisible = views.isEmpty ? false : nil
    }
    
    public func setCustomAccessibilityElements(elements: [Any]) {
        let array = [[topGroupStack], elements, [bodyScrollView], [bottomStack]]
        customAccessibilityElements = array
        
        isAccessibilityElement = false
        accessibilityElements = array.flatMap({ $0 })
    }
    
    public func updateAccessibilityElements() {
        if customAccessibilityElements != nil {
            accessibilityElements = customAccessibilityElements.flatMap({ $0 })
        }
        
        UIAccessibility.post(notification: .layoutChanged, argument: self.topGroupStack.subviews.first)
    }
}

private extension ConstructorScreenView {
    enum Constants {
        // TODO: - check this value with QA. Or move this padding to bottomGroupOrg
        static let bottomGroupBottomPadding: CGFloat = 32
    }
}
