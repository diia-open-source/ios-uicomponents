
import UIKit

public final class VerticalRoundView: UIView {

    override public func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height / 2
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        layer.masksToBounds = true
    }
}
