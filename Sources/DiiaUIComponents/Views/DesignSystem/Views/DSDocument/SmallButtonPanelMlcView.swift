
import UIKit

/// design_system_code: smallEmojiPanelPlaneMlc

public class SmallButtonPanelMlcView: BaseCodeView {
    
    private let panelLabel = UILabel().withParameters(font: FontBook.usualFont,
                                                      numberOfLines: 0)
    private var emojiLabel = UILabel().withParameters(font: FontBook.emojiFont)
    private lazy var contentView = UIView()
    
    public override func setupSubviews() {
        let stack = UIStackView.create(.horizontal,
                                       views: [emojiLabel, panelLabel],
                                       spacing: Constants.padding,
                                       alignment: .center)
        
        let box = BoxView(subview: stack).withConstraints(insets: Constants.stackSubviewInsets)
        box.backgroundColor = Constants.boxColor
        box.layer.cornerRadius = Constants.cornerRadius
        addSubview(box)
        box.fillSuperview()
        box.withHeight(Constants.viewHeight)
        emojiLabel.withSize(Constants.emojiSize)
        contentView = box
    }
    
    public func configure(for model: DSSmallEmojiPanelMlcl, color: UIColor? = nil) {
        emojiLabel.text = Constants.boosterEmoji
        panelLabel.text = model.label
        if let color = color {
            contentView.backgroundColor = color
        }
    }
    
}

extension SmallButtonPanelMlcView {
    enum Constants {
        static let boosterEmoji = "💉"
        static let padding: CGFloat = 8
        static let boxColor = UIColor(white: 1, alpha: 0.4)
        static let cornerRadius: CGFloat = 16
        static let emojiSize = CGSize(width: 16, height: 16)
        static let defaultPadding: CGFloat = 16
        static let viewHeight: CGFloat = 48
        static let stackSubviewInsets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
    }
}
