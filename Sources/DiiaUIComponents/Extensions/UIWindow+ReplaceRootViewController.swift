import UIKit

public extension UIWindow {
    func replaceRootViewControllerWith(_ replacementController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        let snapshotImageView = UIImageView(image: self.snapshot())
        addSubview(snapshotImageView)
        
        let dismissCompletion: () -> Void = {
            self.rootViewController = replacementController
            self.bringSubviewToFront(snapshotImageView)
            if animated {
                UIView.animate(withDuration: 0.4,
                               animations: { snapshotImageView.alpha = 0 },
                               completion: { _ in
                                snapshotImageView.removeFromSuperview()
                                completion?()
                               })
            } else {
                snapshotImageView.removeFromSuperview()
                completion?()
            }
        }
        if let rootViewController = rootViewController, rootViewController.presentedViewController != nil {
            rootViewController.dismiss(animated: false, completion: dismissCompletion)
        } else {
            dismissCompletion()
        }
    }
}
