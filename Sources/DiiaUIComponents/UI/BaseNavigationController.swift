
import UIKit

public final class BaseNavigationController: UINavigationController {

    private lazy var fullScreenPanGestureRecognizer: UIPanGestureRecognizer = {
        let gestureRecognizer = UIPanGestureRecognizer()
        
        if let cachedInteractionController = self.value(forKey: "_cachedInteractionController") as? NSObject {
            let string = "handleNavigationTransition:"
            let selector = Selector(string)
            if cachedInteractionController.responds(to: selector) {
                gestureRecognizer.addTarget(cachedInteractionController, action: selector)
            }
        }
        
        return gestureRecognizer
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer(self.fullScreenPanGestureRecognizer)
        fullScreenPanGestureRecognizer.delegate = self

        self.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        let vc = presentedViewController ?? topViewController
        return vc as? Rotatable != nil ? vc?.supportedInterfaceOrientations ?? .portrait : .portrait
    }
    
    public override var shouldAutorotate: Bool {
        let vc = presentedViewController ?? topViewController
        return vc as? Rotatable != nil && vc?.shouldAutorotate == true
    }
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard viewControllers.count > 1 && (viewControllers.last?.canGoBack() == true),
              let gesture = gestureRecognizer as? UIPanGestureRecognizer,
              gesture.velocity(in: gesture.view).x > abs(gesture.velocity(in: gesture.view).y)
        else {
            return false
        }
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard
            let gesture = gestureRecognizer as? UIPanGestureRecognizer,
            viewControllers.count > 1 && (viewControllers.last?.canGoBack() == true)
        else { return false }
        
        let location = gestureRecognizer.location(in: gestureRecognizer.view)
        let isEdgePan: () -> Bool = {
            if location.x < Constants.leftInsetForSwipe {
                let velocity = gesture.velocity(in: gesture.view)
                if velocity.x >= abs(velocity.y) {
                    otherGestureRecognizer.isEnabled = false
                    otherGestureRecognizer.isEnabled = true
                    return true
                }
            }
            return false
        }
        
        if isViewBackSwipeStopping(view: otherGestureRecognizer.view) {
            gestureRecognizer.isEnabled = false
            gestureRecognizer.isEnabled = true
            return true
        }
        
        if let scrollView = otherGestureRecognizer.view as? UIScrollView {
            let viewIsHorizontalScrollView = scrollView.contentSize.height > CGFloat.ulpOfOne
                && scrollView.contentSize.width > scrollView.contentSize.height
                && abs(scrollView.contentOffset.x + scrollView.contentInset.left) < CGFloat.ulpOfOne
            let viewIsDeceleratingScrollView = scrollView.contentSize.height > scrollView.contentSize.width
                && scrollView.isDecelerating
            if viewIsHorizontalScrollView, viewIsDeceleratingScrollView {
                if viewIsHorizontalScrollView {
                    let velocity = gesture.velocity(in: gesture.view)
                    if velocity.x > CGFloat.ulpOfOne {
                        return false
                    }

                    otherGestureRecognizer.isEnabled = false
                    otherGestureRecognizer.isEnabled = true
                }
                return true
            } else {
                if isEdgePan() {
                    return true
                }
            }
        } else if isEdgePan() {
            return true
        }
        
        return false
    }
    
    // MARK: - Private
    private func isViewBackSwipeStopping(view: UIView?) -> Bool {
        var currentView = view
        while let current = currentView {
            if current as? BackSwipeStopperProtocol != nil {
                return true
            }
            currentView = current.superview
        }
        return false
    }
}

private extension BaseNavigationController {
    enum Constants {
        static let leftInsetForSwipe: CGFloat = 44
    }
}

public protocol BackSwipeStopperProtocol {}

extension UISwitch: BackSwipeStopperProtocol {}
