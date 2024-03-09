import UIKit

public class GradientView: BaseCodeView {
    private let gradientLayer = CAGradientLayer.create()
    
    public override func setupSubviews() {
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }
}
