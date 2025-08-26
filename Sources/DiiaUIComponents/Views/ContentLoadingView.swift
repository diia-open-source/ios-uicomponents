
import UIKit
import Lottie
import DiiaCommonTypes

public class ContentLoadingView: BaseCodeView {
    private lazy var animationView: LottieAnimationView = {
        let animation = LottieAnimation.named(Constants.animationName)
        let lottieView = LottieAnimationView(animation: animation)
        lottieView.loopMode = .loop
        lottieView.backgroundBehavior = .pauseAndRestore
        return lottieView
    }()
    
    private lazy var visualEffectView: UIView = {
        var visualEffectsOff = UIAccessibility.isReduceTransparencyEnabled
        if visualEffectsOff {
            let visualEffectView = UIView()
            visualEffectView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: Constants.backgroundAlpha)
            return visualEffectView
        } else {
            return CustomIntensityVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.light), intensity: Constants.blurIntensity)
        }
    }()
    
    // MARK: - Life Cycle
    public override func setupSubviews() {
        addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        visualEffectView.alpha = 0
        addSubview(animationView)
        animationView.isHidden = true
        animationView.withSize(Constants.animationViewSize)
        animationView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        animationView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        setupAccessibility()
    }
    
    // MARK: - Private methods
    private func setupAccessibility() {
        isAccessibilityElement = true
        accessibilityTraits = .staticText
        accessibilityLabel = R.Strings.general_accessibility_loading_hint.localized()
    }
    
    // MARK: - Public Methods
    public func setLoadingState(_ state: LoadingState, completion: Callback? = nil) {
        animationView.isHidden = state == .ready
        UIView.animate(
            withDuration: Constants.animationDuration,
            animations: {
                self.visualEffectView.alpha = state == .loading ? 1 : 0
            })
        if state == .loading {
            isAccessibilityElement = true
            animationView.play()
        } else {
            isAccessibilityElement = false
            completion?()
            animationView.stop()
        }
    }
}

private extension ContentLoadingView {
    enum Constants {
        static let animationViewSize = CGSize(width: 80, height: 80)
        static let animationName = "loader"
        static let backgroundAlpha: CGFloat = 0.4
        static let blurIntensity: CGFloat = 0.15
        static let animationDuration: Double = 0.2
    }
}
