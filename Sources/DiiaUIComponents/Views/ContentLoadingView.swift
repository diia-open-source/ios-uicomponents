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
    
    // MARK: - Life Cycle
    public override func setupSubviews() {
        animationView.isHidden = true
        addSubview(animationView)
        animationView.withSize(Constants.animationViewSize)
        animationView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        animationView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    // MARK: - Public Methods
    public func setLoadingState(_ state: LoadingState) {
        animationView.isHidden = state == .ready
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
    }
}
