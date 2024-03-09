import UIKit

public extension CALayer {
    func applySketchShadow(color: UIColor = .black,
                           alpha: Float = 0.16,
                           x: CGFloat = 0,
                           y: CGFloat = 1,
                           blur: CGFloat = 6,
                           spread: CGFloat = 0) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
        shouldRasterize = true
        rasterizationScale = UIScreen.main.scale
    }
    
    func clearShadows() {
        shadowOffset = .init(width: 0, height: 0)
        shadowColor = UIColor.clear.cgColor
        cornerRadius = 0.0
        shadowRadius = 0.0
        shadowOpacity = 0.0
    }
}
