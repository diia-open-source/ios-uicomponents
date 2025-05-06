import UIKit

public extension UIView {
    fileprivate func _stack(_ axis: NSLayoutConstraint.Axis = .vertical, views: [UIView], spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill, padding: UIEdgeInsets = .zero) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.alignment = alignment
        stackView.distribution = distribution
        addSubview(stackView)
        stackView.fillSuperview(padding: padding)
        return stackView
    }
    
    @discardableResult
    func stack(_ views: [UIView], spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill, padding: UIEdgeInsets = .zero) -> UIStackView {
        return _stack(.vertical, views: views, spacing: spacing, alignment: alignment, distribution: distribution, padding: padding)
    }
    
    @discardableResult
    func stack(_ views: UIView..., spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill, padding: UIEdgeInsets = .zero) -> UIStackView {
        return _stack(.vertical, views: views, spacing: spacing, alignment: alignment, distribution: distribution, padding: padding)
    }
    
    @discardableResult
    func hstack(_ views: UIView..., spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill, padding: UIEdgeInsets = .zero) -> UIStackView {
        return _stack(.horizontal, views: views, spacing: spacing, alignment: alignment, distribution: distribution, padding: padding)
    }
    
    @discardableResult
    func withSize(_ size: CGSize) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
        return self
    }
    
    @discardableResult
    func withHeight(_ height: CGFloat) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    @discardableResult
    func withWidth(_ width: CGFloat) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        return self
    }
    
    @discardableResult
    func withBorder(width: CGFloat, color: UIColor) -> UIView {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        return self
    }
}

public extension UIView {
    func setVisibility(isVisible: Bool, in stack: UIStackView?, for duration: Double = 0.1) {
        UIView.animate(withDuration: duration) {
            self.isHidden = !isVisible
            stack?.layoutIfNeeded()
        }
    }
    
    func toggleVisibility(in stack: UIStackView?, for duration: Double = 0.2) {
        setVisibility(isVisible: isHidden, in: stack, for: duration)
    }
}

public extension UIEdgeInsets {
    static func allSides(_ side: CGFloat) -> UIEdgeInsets {
        return .init(top: side, left: side, bottom: side, right: side)
    }
}

public extension UIImageView {
    convenience init(image: UIImage?, contentMode: UIView.ContentMode = .scaleAspectFill) {
        self.init(image: image)
        self.contentMode = contentMode
        self.clipsToBounds = true
    }
}
