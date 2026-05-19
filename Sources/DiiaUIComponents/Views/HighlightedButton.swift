
import UIKit

open class HighlightedButton: UIButton {
    override open var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(
                    withDuration: Constants.pressAnimationDuration,
                    delay: 0,
                    options: [.curveEaseInOut, .allowUserInteraction])
                { [weak self] in
                    self?.transform = Constants.pressTransform
                    self?.alpha = Constants.pressAlpha
                }
            } else {
                UIView.animate(
                    withDuration: Constants.releaseAnimationDuration,
                    delay: 0,
                    usingSpringWithDamping: Constants.releaseAnimationSpringWithDamping,
                    initialSpringVelocity: Constants.releaseAnimationSpringVelocity,
                    options: [.allowUserInteraction, .beginFromCurrentState]
                ) { [weak self] in
                    self?.transform = .identity
                    self?.alpha = 1
                }
            }
        }
    }
}

// MARK: - Constants
extension HighlightedButton {
    private enum Constants {
        static let pressAnimationDuration: TimeInterval = 0.12
        static let pressTransform = CGAffineTransform(scaleX: 0.94, y: 0.94)
        static let pressAlpha: CGFloat = 0.5

        static let releaseAnimationDuration: TimeInterval = 0.4
        static let releaseAnimationSpringWithDamping: CGFloat = 0.8
        static let releaseAnimationSpringVelocity: CGFloat = 0.4
    }
}
