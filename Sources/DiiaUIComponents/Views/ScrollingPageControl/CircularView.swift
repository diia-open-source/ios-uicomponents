import UIKit

class CircularView: UIView {
    override func tintColorDidChange() {
        self.backgroundColor = tintColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateAppearance()
    }
    
    override var frame: CGRect {
        didSet {
            updateAppearance()
        }
    }
    
    private func updateAppearance() {
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
        layer.masksToBounds = true
    }
    
}
