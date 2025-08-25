import UIKit

extension UIViewController {
    public class var className: String { String(describing: self) }
    
    public func topNonNavigationParent() -> UIViewController {
        var topParent = self
        while let nextParent = topParent.parent, (nextParent as? UINavigationController) == nil {
            topParent = nextParent
        }
        
        return topParent
    }

    // MARK: - Helping Navigation Methods
    @objc open func canGoBack() -> Bool {
        if !view.isUserInteractionEnabled { return false }
        for child in children {
            if child as? ModalPresentationViewControllerProtocol != nil {
                return false
            }
        }
        return true
    }
    
    // TODO: - Remove after Authorization fix https://diia.atlassian.net/browse/IOS-7095
    @objc open func removeAccessibilityElements() { }
    @objc open func updateAccessibilityElements() { }
}
