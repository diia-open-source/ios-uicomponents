
import Lottie

public extension LottieAnimationView {
    static func loadingPlaceholder(animationName: String = "placeholder_white") -> LottieAnimationView {
        let animation = LottieAnimation.named(animationName)
        let lottieView = LottieAnimationView(animation: animation)
        lottieView.loopMode = .loop
        lottieView.backgroundBehavior = .pauseAndRestore
        return lottieView
    }
}
