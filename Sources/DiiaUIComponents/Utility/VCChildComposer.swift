
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
        parentViewController.addChild(childViewController)
        childViewController.willMove(toParent: parentViewController)
        
        view.addSubview(childViewController.view)
        childViewController.view.fillSuperview()
        
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
        default:
            childViewController.didMove(toParent: parentViewController)
            return
        }
        
        UIView.animate(withDuration: 0.3,
                       animations: {
                        childViewController.view.alpha = 1
                        childViewController.view.transform = .identity
                    },
                       completion: { _ in
                        childViewController.didMove(toParent: parentViewController)
                        log("presenting finished")
                    })
    }
    
    public static func removeChild(
        _ childViewController: UIViewController,
        from parentViewController: UIViewController,
        animationType: ChildAnimationStyle
    ) {
        let removingAction = {
            childViewController.view.removeFromSuperview()
            childViewController.removeFromParent()
        }
        if childViewController.view.window == nil {
            removingAction()
            return
        }
        
        guard let snapShot = childViewController.view.snapshotView(afterScreenUpdates: false),
            let superview = childViewController.view.superview else {
            removingAction()
            return
        }
        snapShot.frame = childViewController.view.frame
        superview.addSubview(snapShot)
        
        removingAction()
        
        let completion = {
            snapShot.removeFromSuperview()
        }
        var animations: Callback = {}
        
        switch animationType {
        case .top:
            animations = {
                snapShot.frame.origin.y = -childViewController.view.frame.height
            }
        case .left:
            animations = {
                snapShot.frame.origin.x = -childViewController.view.frame.width
            }
        case .right:
            animations = {
                snapShot.frame.origin.x = childViewController.view.frame.width
            }
        case .bottom:
            animations = {
                snapShot.frame.origin.y = childViewController.view.frame.height
            }
        case .fadeIn:
            animations = {
                snapShot.alpha = 0
            }
        default:
            completion()
            return
        }
        
        UIView.animate(withDuration: 0.3,
                       animations: { animations() },
                       completion: { _ in completion() })
    }
}
