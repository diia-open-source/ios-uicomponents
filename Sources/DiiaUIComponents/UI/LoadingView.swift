
import UIKit
import Lottie

public final class LoadingView: BaseCodeView {
    
    // MARK: - Static
    public static weak var globalLoadingView: LoadingView?
    
    public static func showGlobal(in view: UIView) {
        if globalLoadingView != nil {
            hideGlobal()
        }
        globalLoadingView = show(in: view)
        
        UIAccessibility.post(notification: .layoutChanged, argument: globalLoadingView)
    }
    
    public static func hideGlobal() {
        globalLoadingView?.hide()
        globalLoadingView = nil
    }
    
    @discardableResult
    public static func show(in view: UIView) -> LoadingView {
        let loadingView = LoadingView()
        
        loadingView.isAccessibilityElement = true
        loadingView.accessibilityTraits = .staticText
        loadingView.accessibilityViewIsModal = true
        loadingView.accessibilityLabel = R.Strings.general_accessibility_loading_hint.localized()
        
        view.isUserInteractionEnabled = false
        loadingView.visualEffectView.alpha = 0
        view.addSubview(loadingView)
        loadingView.fillSuperview()
        
        loadingView.animationView.play()
        UIView.animate(withDuration: Constants.showingAnimationDuration,
                       animations: {
            loadingView.visualEffectView.alpha = 1
        })
        
        return loadingView
    }
    
    // MARK: - Private
    private lazy var visualEffectView: UIView = {
        let visualEffectView = UIView()
        visualEffectView.backgroundColor = Constants.backgroundColor
        return visualEffectView
    }()
    
    private lazy var animationView: LottieAnimationView = {
        let animation = LottieAnimation.named(Constants.animationName, bundle: Bundle.module)
        let lottieView = LottieAnimationView(animation: animation)
        lottieView.loopMode = .loop
        lottieView.backgroundBehavior = .pauseAndRestore
        return lottieView
    }()
    
    public override func setupSubviews() {
        addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        
        addSubview(animationView)
        animationView.withSize(Constants.animationViewSize)
        animationView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        animationView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    public func hide() {
        superview?.isAccessibilityElement = false
        superview?.accessibilityViewIsModal = false
        
        superview?.isUserInteractionEnabled = true
        layer.removeAllAnimations()
        UIView.animate(withDuration: Constants.hidingAnimationDuration,
                       animations: {
            self.visualEffectView.alpha = 0
        }, completion: { [weak self] _ in
            self?.animationView.stop()
            self?.removeFromSuperview()
        })
    }
}

private extension LoadingView {
    enum Constants {
        static let backgroundColor = UIColor.black.withAlphaComponent(0.6)
        static let animationViewSize = CGSize(width: 80, height: 80)
        static let animationName = "loader_white"
        static let hidingAnimationDuration: TimeInterval = 0.3
        static let showingAnimationDuration: TimeInterval = 0.1
    }
}
