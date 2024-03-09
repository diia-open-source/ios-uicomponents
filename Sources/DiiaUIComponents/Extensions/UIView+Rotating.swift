import UIKit

public extension UIView {
    private static let rotationAnimationKey = "rotationAnimationKey"
    
    func startRotating(duration: CFTimeInterval = 1) {
        guard self.layer.animation(forKey: UIView.rotationAnimationKey) == nil else { return }
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.fromValue = 0
        animation.toValue = 2 * Float.pi
        animation.duration = duration
        animation.repeatCount = Float.infinity
        
        layer.add(animation, forKey: UIView.rotationAnimationKey)
    }
    
    func stopRotation() {
        layer.removeAnimation(forKey: UIView.rotationAnimationKey)
    }
}
