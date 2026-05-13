
import UIKit

public final class VerticalRoundButton: HighlightedButton {
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height / 2
    }
}
