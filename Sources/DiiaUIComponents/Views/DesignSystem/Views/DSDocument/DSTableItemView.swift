
import UIKit

public class DSTableItemView: BaseCodeView {
        
    internal var label = UILabel()
    internal var subLabel = UILabel()
    internal var value = UILabel()
    internal var subValue = UILabel()
    internal var supportLabel = UILabel()
    internal var icon = UIImageView()
    internal var actionButton = ActionButton(type: .icon)
        
    internal func setupUI() {
        actionButton.withSize(Constants.buttonSize)
        actionButton.iconRenderingMode = .alwaysOriginal
        
        label.isHidden = true
        subLabel.isHidden = true
        value.isHidden = true
        subValue.isHidden = true
        supportLabel.isHidden = true
        icon.isHidden = true
        actionButton.isHidden = true
        
        label.numberOfLines = 0
        subLabel.numberOfLines = 0
        supportLabel.numberOfLines = 0
        value.numberOfLines = 0
        subValue.numberOfLines = 0
        
        label.font = FontBook.usualFont
        subLabel.font = FontBook.usualFont
        value.font = FontBook.usualFont
        supportLabel.font = FontBook.usualFont
        subValue.font = FontBook.usualFont
        
        subValue.textColor = Constants.lightBlack
        subLabel.textColor = Constants.lightBlack
        
        icon.contentMode = .scaleAspectFit
    }
}

extension DSTableItemView {
    enum Constants {
        static let lightBlack = UIColor.black.withAlphaComponent(0.4)
        static let buttonSize = CGSize(width: 24, height: 24)
    }
}
