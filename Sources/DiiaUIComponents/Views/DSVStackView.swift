
import UIKit

public class DSVStackView: BaseCodeView {
    private var arrangedSubviews: [UIView] = []
    
    private var heightConstraint: NSLayoutConstraint?
    private var calculatedHeight: CGFloat = 0
    private var previousLayoutWidth: CGFloat = 0
    
    public override func setupSubviews() {
        clearSubviews()
        heightConstraint = heightAnchor.constraint(equalToConstant: 0)
        heightConstraint?.isActive = true
    }
    
    public func addArrangedSubviews(_ subviews: [UIView]) {
        for view in subviews {
            addSubviewToBottom(view)
        }
        heightConstraint?.constant = calculatedHeight
        layoutIfNeeded()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        let width = frame.width
        if width != previousLayoutWidth {
            previousLayoutWidth = width
            recalculateArrangedSubviewsFrames()
        }
    }
    
    public func clearSubviews() {
        calculatedHeight = 0
        heightConstraint?.constant = 0
        subviews.forEach { $0.removeFromSuperview() }
        arrangedSubviews = []
        layoutIfNeeded()
    }
    
    private func addSubviewToBottom(_ subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = true
        let size = subview.systemLayoutSizeFitting(.init(width: self.bounds.width, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        let origin: CGPoint = .init(x: .zero, y: calculatedHeight)
        subview.frame = .init(origin: origin, size: size)
        calculatedHeight += size.height
        arrangedSubviews.append(subview)
    }
    
    private func recalculateArrangedSubviewsFrames() {
        calculatedHeight = 0
        for subview in arrangedSubviews {
            let size = subview.systemLayoutSizeFitting(.init(width: self.bounds.width, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
            let origin: CGPoint = .init(x: .zero, y: calculatedHeight)
            subview.frame = .init(origin: origin, size: size)
            calculatedHeight += size.height
        }
        heightConstraint?.constant = calculatedHeight
        layoutIfNeeded()
    }
}
