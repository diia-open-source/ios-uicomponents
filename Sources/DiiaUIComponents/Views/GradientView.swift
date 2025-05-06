import UIKit

public class GradientView: BaseCodeView {
    private var gradientLayer = CAGradientLayer.create()
    
    public override func setupSubviews() {
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.isUserInteractionEnabled = false
    }
    
    public func configureGradient(for colors: [UIColor],
                                  corner: CGFloat = 0,
                                  startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0),
                                  endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0)) {
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.cornerRadius = corner
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }
}
