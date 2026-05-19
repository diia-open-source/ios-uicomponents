
import UIKit
import DiiaCommonTypes

public enum ChildAnimationStyle {
    case none
    case top
    case left
    case right
    case bottom
    case fadeIn
}

public struct VCChildComposer {
    public static func addChild(
        _ childViewController: UIViewController,
        to parentViewController: UIViewController,
        in parentView: UIView? = nil,
        animationType: ChildAnimationStyle
    ) {
        let view: UIView = parentView ?? parentViewController.view
        
        view.addSubview(childViewController.view)
        childViewController.view.fillSuperview()

        parentViewController.addChild(childViewController)

        switch animationType {
        case .top:
            childViewController.view.transform = .init(translationX: 0, y: -childViewController.view.frame.height)
        case .left:
            childViewController.view.transform = .init(translationX: -childViewController.view.frame.width, y: 0)
        case .right:
            childViewController.view.transform = .init(translationX: childViewController.view.frame.width, y: 0)
        case .bottom:
            childViewController.view.transform = .init(translationX: 0, y: childViewController.view.frame.height)
        case .fadeIn:
            childViewController.view.alpha = 0
        case .none:
            childViewController.didMove(toParent: parentViewController)
            return
        }
        
        UIView.animate(
            withDuration: 0.3,
            animations: { [weak childViewController] in
                childViewController?.view.alpha = 1
                childViewController?.view.transform = .identity
            },
            completion: { [weak childViewController, weak parentViewController] _ in
                guard let childViewController else { return }
                childViewController.didMove(toParent: parentViewController)
                log("presenting finished")
            }
        )
    }
    
    public static func removeChild(
        _ childViewController: UIViewController,
        from parentViewController: UIViewController,
        animationType: ChildAnimationStyle
    ) {
        childViewController.willMove(toParent: nil)
        
        let removingAction = {
            childViewController.view.removeFromSuperview()
            childViewController.removeFromParent()
        }
        
        guard childViewController.view.window != nil else {
            removingAction()
            return
        }
        
        guard
            let snapShot = childViewController.view.snapshotView(afterScreenUpdates: false),
            let superview = childViewController.view.superview
        else {
            removingAction()
            return
        }
        
        let childFrame = childViewController.view.frame
        snapShot.frame = childFrame
        superview.addSubview(snapShot)
        
        removingAction()
        
        let completion = {
            snapShot.removeFromSuperview()
        }
        
        let animations: Callback
        
        switch animationType {
        case .top:
            animations = {
                snapShot.frame.origin.y = -childFrame.height
            }
        case .left:
            animations = {
                snapShot.frame.origin.x = -childFrame.width
            }
        case .right:
            animations = {
                snapShot.frame.origin.x = childFrame.width
            }
        case .bottom:
            animations = {
                snapShot.frame.origin.y = childFrame.height
            }
        case .fadeIn:
            animations = {
                snapShot.alpha = 0
            }
        case .none:
            completion()
            return
        }
        
        UIView.animate(
            withDuration: 0.3,
            animations: { animations() },
            completion: { _ in completion() }
        )
    }
}
