
import UIKit

final class ConstructorPaginationScreenView: BaseCodeView {
    
    public let backgroundImageView = UIImageView()
    public let loadingView = ContentLoadingView()
    let topGroupStack: UIStackView = .create()
    let bodyTableView = UITableView()
    let bottomStack: UIStackView = .create()
    
    var bottomGroupBottomConstraint: NSLayoutConstraint?
    private var bottomGroupHeightConstraint: NSLayoutConstraint?
    
    override func setupSubviews() {
        addSubview(backgroundImageView)
        backgroundImageView.fillSuperview()
        addSubview(loadingView)
        loadingView.fillSuperview()
        loadingView.setLoadingState(.ready)
        
        addSubviews([topGroupStack, bodyTableView, bottomStack])
        
        topGroupStack.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        bodyTableView.anchor(top: topGroupStack.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        bottomStack.anchor(top: bodyTableView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        
        bottomGroupHeightConstraint = bottomStack.heightAnchor.constraint(equalToConstant: 0)
        bottomGroupBottomConstraint = bottomAnchor.constraint(equalTo: bottomStack.bottomAnchor, constant: 0)
        bottomGroupBottomConstraint?.isActive = true
    }
    
    func setupTopGroup(views: [UIView]) {
        topGroupStack.safelyRemoveArrangedSubviews()
        topGroupStack.addArrangedSubviews(views)
    }
    
    func setupBottomGroup(views: [UIView]) {
        bottomStack.safelyRemoveArrangedSubviews()
        bottomStack.addArrangedSubviews(views)
        
        if views.isEmpty {
            bottomGroupHeightConstraint?.isActive = true
            bottomGroupBottomConstraint?.constant = 0
            let bottomInset = safeAreaInsets.bottom > 0 ? safeAreaInsets.bottom : Constants.bottomGroupBottomPadding
            bodyTableView.contentInset.bottom = bottomInset
        } else {
            bottomGroupHeightConstraint?.isActive = false
            let bottomInset = safeAreaInsets.bottom > 0 ? safeAreaInsets.bottom : Constants.bottomGroupBottomPadding
            bottomGroupBottomConstraint?.constant = bottomInset
            bodyTableView.contentInset.bottom = 0
        }
    }
}

// MARK: - UITableView Delegate & DataSource
private extension ConstructorPaginationScreenView {
    enum Constants {
        static let bottomGroupBottomPadding: CGFloat = 32
    }
}
