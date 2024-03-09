import UIKit

public class VerticalRoundButton: UIButton {

    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height / 2
    }
}
