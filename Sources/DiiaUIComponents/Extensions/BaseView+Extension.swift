import UIKit
import DiiaMVPModule
import SwiftMessages

public extension DiiaMVPModule.BaseView where Self: UIViewController {
    func open(module: BaseModule) {
        guard let navigation = navigationController else {
            return
        }
        view.endEditing(true)
        // Pushing a navigation controller is not supported
        if (module.viewController() as? UINavigationController) == nil {
            navigation.pushViewController(module.viewController(), animated: true)
        } else if let navModule = (module.viewController() as? UINavigationController) {
            navigation.pushViewController(navModule.viewControllers[0], animated: true)
        }
    }
    
    func present(module: BaseModule) {
        view.endEditing(true)
        let vc = module.viewController()
        if vc as? UINavigationController != nil {
            present(vc, animated: true, completion: nil)
            return
        }
        let nc = UINavigationController(rootViewController: vc)
        nc.isNavigationBarHidden = true
        nc.modalPresentationStyle = vc.modalPresentationStyle
        present(nc, animated: true, completion: nil)
    }
    
    func replace(with module: BaseModule, animated: Bool = true) {
        guard let navigation = navigationController,
              (module.viewController() as? UINavigationController) == nil
        else {
            return
        }
        navigation.replaceTopViewController(with: module.viewController(), animated: animated)
    }
    
    func openAsRoot(module: BaseModule) {
        let window: UIWindow? = UIApplication.shared.keyWindow
        window?.replaceRootViewControllerWith(module.viewController(), animated: true, completion: nil)
    }
    
    func closeToRoot(animated: Bool = true) {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: animated)
        }
    }
    
    func showMessage(message: String) {
        let messageView = MessageView.viewFromNib(layout: .cardView)
        messageView.configureTheme(.warning)
        messageView.configureContent(body: message)
        messageView.titleLabel?.text = nil
        messageView.button?.setTitle(nil, for: .normal)
        messageView.button?.backgroundColor = .clear
        messageView.button?.tintColor = .clear
        SwiftMessages.show(view: messageView)
    }

    func showSuccessMessage(message: String) {
        let messageView = MessageView.viewFromNib(layout: .statusLine)
        messageView.configureTheme(backgroundColor: .init("#65C680"), foregroundColor: .black)
        messageView.configureContent(body: message)
        messageView.backgroundHeight = 84.0
        messageView.bodyLabel?.font = FontBook.usualFont
        messageView.constraints.forEach({
            if $0.firstItem is UILabel || $0.secondItem is UILabel {
                $0.isActive = false
            }
        })
        messageView.bodyLabel?.fillSuperview(padding: .init(top: 50, left: 24, bottom: 12, right: 24))
        SwiftMessages.show(view: messageView)
    }

    func showError(error: String) {
        let messageView = MessageView.viewFromNib(layout: .statusLine)
        messageView.configureTheme(backgroundColor: .init("#FAEB64"), foregroundColor: .black)
        messageView.configureContent(body: error)
        messageView.titleLabel?.text = nil
        messageView.button?.setTitle(nil, for: .normal)
        messageView.button?.backgroundColor = .clear
        messageView.button?.tintColor = .clear
        SwiftMessages.show(view: messageView)
    }
    
    func closeModule(animated: Bool) {
        if let presented = parent as? ModalPresentationViewControllerProtocol {
            presented.close(animated: animated)
        } else if let navigationController = navigationController,
                  presentingViewController != nil, navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: animated)
        } else if presentingViewController != nil {
            dismiss(animated: animated, completion: nil)
        } else if let navigationController = navigationController {
            navigationController.popViewController(animated: animated)
        }
    }
    
    func closeToModule(module: DiiaMVPModule.BaseModule) {
        let targetVC = module.viewController().topNonNavigationParent()
        if let navigation = navigationController, navigation.viewControllers.contains(targetVC) {
            navigation.popToViewController(targetVC, animated: true)
        }
    }

    func closeToView(view: DiiaMVPModule.BaseView?, animated: Bool = true) {
        if let navigationController = navigationController,
           let topParent = (view as? UIViewController)?.topNonNavigationParent(),
           navigationController.viewControllers.contains(topParent) {
            navigationController.popToViewController(topParent, animated: animated)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    func showProgress() {
        var topVC: UIViewController = self
        while let parent = topVC.parent { topVC = parent }
        LoadingView.showGlobal(in: topVC.view )
    }
    
    func hideProgress() {
        LoadingView.hideGlobal()
    }
    
    func showChild(module: BaseModule) {
        view.endEditing(true)
        let child = module.viewController()
        let topVC = self.topNonNavigationParent()
        VCChildComposer.addChild(child, to: topVC, animationType: .none)
    }
}
