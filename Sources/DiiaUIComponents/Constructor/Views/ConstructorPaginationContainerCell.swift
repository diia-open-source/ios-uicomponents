
import UIKit

public final class ConstructorPaginationContainerCell: UITableViewCell, Reusable {
    private var subview: UIView?
    private var separatorView: UIView?
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Public
    public func setSubview(_ subview: UIView) {
        guard self.subview != subview else { return }
        
        self.contentView.subviews.forEach { $0.removeFromSuperview() }
        self.subview = subview
  
        contentView.addSubview(subview)
        let anchoredConstraints = subview.fillSuperview()
        anchoredConstraints.bottom?.priority = .defaultLow
        layoutIfNeeded()
    }
    
    public func showSeparator(_ isVisible: Bool) {
        if isVisible {
            guard separatorView == nil else { return }
            addSeparator()
        } else {
            removeSeparator()
        }
    }
    
    // MARK: - Private
    private func initialSetup() {
        self.backgroundColor = .clear
    }
    
    private func makeSeparator() -> UIView {
        let view = UIView()
        view.withHeight(Constants.separatorHeight)
        view.backgroundColor = Constants.separatorColor
        return view
    }
    
    private func addSeparator() {
        let separatorView = makeSeparator()
        contentView.addSubview(separatorView)
        separatorView
            .anchor(
                leading: contentView.leadingAnchor,
                bottom: contentView.bottomAnchor,
                trailing: contentView.trailingAnchor,
                padding: Constants.separatorPadding
            )
    }
    
    private func removeSeparator() {
        separatorView?.removeFromSuperview()
    }
}

// MARK: - ConstructorPaginationContainerCell + Constants
private extension ConstructorPaginationContainerCell {
    enum Constants {
        static let separatorHeight: CGFloat = 2
        static let separatorColor = UIColor("#CADDEB")
        static let separatorPadding = UIEdgeInsets(top: .zero, left: 24.0, bottom: .zero, right: 24.0)
    }
}
