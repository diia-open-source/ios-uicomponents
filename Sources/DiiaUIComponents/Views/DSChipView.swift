
import UIKit

public final class DSChipView: BaseCodeView {
    private let textLabel = UILabel().withParameters(font: FontBook.statusFont, numberOfLines: 1)
    
    // MARK: - Init
    public override func setupSubviews() {
        layer.masksToBounds = true
        
        addSubview(textLabel)
        textLabel.fillSuperview(padding: Constants.textPaddings)
    }
    
    public override var intrinsicContentSize: CGSize {
        let size = textLabel.intrinsicContentSize
        return CGSize(
            width: size.width + Constants.textPaddings.left + Constants.textPaddings.right,
            height: size.height + Constants.textPaddings.top + Constants.textPaddings.bottom
        )
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
    
    public func configure(for model: DSCardStatusChipModel) {
        textLabel.text = model.name
        textLabel.textColor = UIColor(model.statusTextColor)
        backgroundColor = UIColor(model.statusViewColor)
        withBorder(width: Constants.borderWidth, color: model.borderColor, cornerRadius: frame.height / 2)
        setNeedsLayout()
        layoutIfNeeded()
    }
}

// MARK: - Constants
private extension DSChipView {
    enum Constants {
        static let borderWidth: CGFloat = 1
        static let textPaddings = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
    }
}
