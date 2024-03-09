import UIKit

public class BoxView<T: UIView>: UIView {
    public let subview: T
    private var subviewConstraints: AnchoredConstraints?
    
    public init(subview: T) {
        self.subview = subview
        super.init(frame: .zero)
    
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        subviewConstraints = subview.fillSuperview()
    }
    
    @discardableResult
    public func withConstraints(insets: UIEdgeInsets = .zero, size: CGSize = .zero, centeredX: Bool = false, centeredY: Bool = false) -> BoxView<T> {
        if insets != .zero {
            subviewConstraints?.top?.constant = insets.top
            subviewConstraints?.bottom?.constant = -insets.bottom
            subviewConstraints?.leading?.constant = insets.left
            subviewConstraints?.trailing?.constant = -insets.right
        }
        
        subviewConstraints?.leading?.isActive = !centeredX
        subviewConstraints?.trailing?.isActive = !centeredX
        subview.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = centeredX
        
        subviewConstraints?.top?.isActive = !centeredY
        subviewConstraints?.bottom?.isActive = !centeredY
        subview.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = centeredY
        
        if size.width != 0 {
            if subviewConstraints?.width == nil {
                subviewConstraints?.width = subview.widthAnchor.constraint(equalToConstant: size.width)
                subviewConstraints?.width?.isActive = true
            } else {
                subviewConstraints?.width?.constant = size.width
            }
        }
        
        if size.height != 0 {
            if subviewConstraints?.height == nil {
                subviewConstraints?.height = subview.heightAnchor.constraint(equalToConstant: size.height)
                subviewConstraints?.height?.isActive = true
            } else {
                subviewConstraints?.height?.constant = size.height
            }
        }
        
        layoutIfNeeded()
        return self
    }
}
