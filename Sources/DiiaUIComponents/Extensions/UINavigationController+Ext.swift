
import UIKit

public extension UINavigationController {
    func replaceTopViewController(with viewController: UIViewController, animated: Bool) {
        replaceTopViewControllers(count: 1, with: [viewController], animated: animated)
    }
    
    func replaceTopViewControllers(count: Int, with viewControllers: [UIViewController], animated: Bool) {
        var vcs = self.viewControllers
        if count <= vcs.count {
            vcs.removeLast(count)
            vcs.append(contentsOf: viewControllers)
        } else {
            vcs = viewControllers
        }
        setViewControllers(vcs, animated: animated)
    }
    
    func replaceViewControllers(with replacingViewControllers: [UIViewController], after referenceViewController: UIViewController, includingReference: Bool = false, animated: Bool = true) {
        if let index = viewControllers.lastIndex(of: referenceViewController.topNonNavigationParent()) {
            replaceTopViewControllers(
                count: viewControllers.count - index - (includingReference ? 0 : 1),
                with: replacingViewControllers,
                animated: animated
            )
        }
    }
    
    func pushViewController(_ viewController: UIViewController,
                            animated: Bool,
                            completion: (() -> Void)?) {
        pushViewController(viewController, animated: animated)
        doAfterAnimation(animated: animated, completion: completion)
    }
    
    func popViewController(animated: Bool,
                           completion: (() -> Void)?) {
        popViewController(animated: animated)
        doAfterAnimation(animated: animated, completion: completion)
    }
    
    func setViewControllers(_ viewControllers: [UIViewController],
                            animated: Bool,
                            completion: (() -> Void)?) {
        setViewControllers(viewControllers, animated: animated)
        doAfterAnimation(animated: animated, completion: completion)
    }
    
    private func doAfterAnimation(animated: Bool, completion: (() -> Void)?) {
        guard let completion = completion else { return }
        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion() }
            return
        }

        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
}
