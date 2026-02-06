
import UIKit

public extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.16,
        x: CGFloat = 0,
        y: CGFloat = 1,
        blur: CGFloat = 6,
        spread: CGFloat = 0
    ) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0

        let rect = bounds.insetBy(dx: -spread, dy: -spread)
        shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        
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
