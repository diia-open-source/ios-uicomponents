import UIKit

public extension UIStackView {
    
    @discardableResult
    static func create(_ axis: NSLayoutConstraint.Axis = .vertical,
                       views: [UIView] = [],
                       spacing: CGFloat = 0,
                       alignment: UIStackView.Alignment = .fill,
                       distribution: UIStackView.Distribution = .fill,
                       in view: UIView? = nil,
                       padding: UIEdgeInsets = .zero) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.alignment = alignment
        stackView.distribution = distribution
        if let view = view {
            view.addSubview(stackView)
            stackView.fillSuperview(padding: padding)
        }
        return stackView
    }
    
    func safelyRemoveArrangedSubviews() {
        // Remove all the arranged subviews and save them to an array
        let removedSubviews = arrangedSubviews.reduce([]) { (sum, next) -> [UIView] in
            self.removeArrangedSubview(next)
            return sum + [next]
        }
        
        // Deactive all constraints at once
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
    
    func safelyRemoveArrangedSubview(at index: Int) {
        if arrangedSubviews.indices.contains(index) {
            let removedSubview = arrangedSubviews[index]
            self.removeArrangedSubview(removedSubview)
            NSLayoutConstraint.deactivate(removedSubview.constraints)
            removedSubview.removeFromSuperview()
        }
    }

    func safelyRemoveArrangedSubview(subview: UIView) {
        self.removeArrangedSubview(subview)
        NSLayoutConstraint.deactivate(subview.constraints)
        subview.removeFromSuperview()
    }
    
    @discardableResult
    func withMargins(_ margins: UIEdgeInsets) -> UIStackView {
        layoutMargins = margins
        isLayoutMarginsRelativeArrangement = true
        return self
    }
    
    @discardableResult
    func padLeft(_ left: CGFloat) -> UIStackView {
        isLayoutMarginsRelativeArrangement = true
        layoutMargins.left = left
        return self
    }
    
    @discardableResult
    func padTop(_ top: CGFloat) -> UIStackView {
        isLayoutMarginsRelativeArrangement = true
        layoutMargins.top = top
        return self
    }
    
    @discardableResult
    func padBottom(_ bottom: CGFloat) -> UIStackView {
        isLayoutMarginsRelativeArrangement = true
        layoutMargins.bottom = bottom
        return self
    }
    
    @discardableResult
    func padRight(_ right: CGFloat) -> UIStackView {
        isLayoutMarginsRelativeArrangement = true
        layoutMargins.right = right
        return self
    }
    
    func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach { self.addArrangedSubview($0) }
    }
}
