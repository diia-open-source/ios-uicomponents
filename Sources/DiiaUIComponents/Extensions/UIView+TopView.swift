import UIKit

public extension UIView {
    func toFront() {
        topView().bringSubviewToFront(self)
    }
    
    func topView() -> UIView {
        var topView: UIView = self
        while let superview = topView.superview {
            topView = superview
        }
        
        return topView
    }
}
