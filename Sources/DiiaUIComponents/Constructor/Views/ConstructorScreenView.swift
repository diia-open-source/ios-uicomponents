
import UIKit

public class ConstructorScreenView: BaseCodeView {
    
    public let backgroundImageView = UIImageView()
    public let loadingView = ContentLoadingView()
    public let topGroupStack: UIStackView = .create(views: [])
    public let bodyStack: UIStackView = .create(views: [])
    public let bodyScrollView: ExtendedScrollView = .init()
    public let bottomStack: UIStackView = .create(views: [])
    
    public var bottomGroupBottomConstraint: NSLayoutConstraint?
    private var bottomGroupHeightConstraint: NSLayoutConstraint?

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
    }
    
    public func setupTopGroup(views: [UIView]) {
        topGroupStack.safelyRemoveArrangedSubviews()
        topGroupStack.addArrangedSubviews(views)
    }
    
    public func setupBody(views: [UIView]) {
        bodyStack.safelyRemoveArrangedSubviews()
        bodyStack.addArrangedSubviews(views)
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
}

private extension ConstructorScreenView {
    enum Constants {
        // TODO: - check this value with QA. Or move this padding to bottomGroupOrg
        static let bottomGroupBottomPadding: CGFloat = 32
    }
}
