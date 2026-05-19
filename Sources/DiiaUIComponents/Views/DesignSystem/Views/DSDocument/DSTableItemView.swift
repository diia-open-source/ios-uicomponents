
import UIKit

public class DSTableItemView: BaseCodeView {
        
    internal var label = UILabel()
    internal var subLabel = UILabel()
    internal var value = UITextView()
    internal var subValue = UILabel()
    internal var textLabel = UILabel().withParameters(font: FontBook.bigText, textAlignment: .left)
    internal var strikeTextLabel = UILabel().withParameters(font: FontBook.bigText, textColor: .black540, textAlignment: .left)
    internal var blueIconLeft = DSIconView().withSize(Constants.blueIconLeftSize)
    internal var blueTextLabel = UILabel()
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
        textLabel.isHidden = true
        strikeTextLabel.isHidden = true
        blueIconLeft.isHidden = true
        blueTextLabel.isHidden = true
        supportLabel.isHidden = true
        icon.isHidden = true
        actionButton.isHidden = true
        
        label.numberOfLines = 0
        subLabel.numberOfLines = 0
        supportLabel.numberOfLines = 0
        value.textContainer.maximumNumberOfLines = 0
        subValue.numberOfLines = 0
        
        label.font = FontBook.usualFont
        subLabel.font = FontBook.usualFont
        value.font = FontBook.usualFont
        supportLabel.font = FontBook.usualFont
        subValue.font = FontBook.usualFont
        blueTextLabel.font = FontBook.usualFont
        
        subValue.textColor = Constants.lightBlack
        subLabel.textColor = Constants.lightBlack
        blueTextLabel.textColor = Constants.blueTextColor
        
        icon.contentMode = .scaleAspectFit
        blueIconLeft.contentMode = .scaleAspectFit
        blueIconLeft.tintColor = Constants.blueTextColor
    }
}

extension DSTableItemView {
    enum Constants {
        static let lightBlack = UIColor.black.withAlphaComponent(0.4)
        static let buttonSize = CGSize(width: 24, height: 24)
        static let blueIconLeftSize = CGSize(width: 16, height: 16)
        static let blueTextColor = UIColor("#0075FB")
    }
}
