import UIKit
import Lottie

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
    }
    
    // MARK: - Public Methods
    public func setLoadingState(_ state: LoadingState) {
        animationView.isHidden = state == .ready
        UIView.animate(
            withDuration: Constants.animationDuration,
            animations: {
                self.visualEffectView.alpha = state == .loading ? 1 : 0
            })
        if state == .loading {
            animationView.play()
        } else {
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
