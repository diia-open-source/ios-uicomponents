
import SwiftUI
import UIKit
import DiiaMVPModule

@available(iOS 13.0, *)
public protocol NavigableSwiftUIView: View {
    var navigation: NavigationHolder { get }
}

@available(iOS 13.0, *)
public final class SwiftUIWrapperController<Content: NavigableSwiftUIView>: UIHostingController<Content>, BaseView {
    public init(content: Content) {
        super.init(rootView: content)
        content.navigation.baseView = self
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@available(iOS 13.0, *)
public final class NavigationHolder: ObservableObject, BaseView {
    public weak var baseView: BaseView?

    public init () {}
    
    public func open(module: BaseModule) {
        baseView?.open(module: module)
    }
    
    public func showChild(module: BaseModule) {
        baseView?.showChild(module: module)
    }
    
    public func present(module: BaseModule) {
        baseView?.present(module: module)
    }
    
    public func replace(with module: BaseModule, animated: Bool) {
        baseView?.replace(with: module, animated: animated)
    }
    
    public func openAsRoot(module: BaseModule) {
        baseView?.openAsRoot(module: module)
    }
    
    public func closeModule(animated: Bool) {
        baseView?.closeModule(animated: animated)
    }
    
    public func closeToRoot(animated: Bool) {
        baseView?.closeToRoot(animated: animated)
    }
    
    public func closeToView(view: BaseView?, animated: Bool) {
        baseView?.closeToView(view: view, animated: animated)
    }
    
    public func showProgress() {
        baseView?.showProgress()
    }
    
    public func hideProgress() {
        baseView?.hideProgress()
    }
    
    public func showError(error: String) {
        baseView?.showError(error: error)
    }
    
    public func showMessage(message: String) {
        baseView?.showMessage(message: message)
    }
    
    public func showSuccessMessage(message: String) {
        baseView?.showSuccessMessage(message: message)
    }
}
