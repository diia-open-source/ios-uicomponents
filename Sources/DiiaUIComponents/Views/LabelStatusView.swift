
import UIKit

public class LabelStatusView: BaseCodeView {
    private let container = UIView()
    private let statusLabel = UILabel().withParameters(font: FontBook.usualFont)

    // MARK: - Life Cycle
    public override func setupSubviews() {
        backgroundColor = .clear
        addSubview(container)
        container.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil)
        container.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor).isActive = true
        
        container.addSubview(statusLabel)
        statusLabel.fillSuperview(padding: Constants.labelInsets)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        container.layer.cornerRadius = container.bounds.height / 2
    }
    
    // MARK: - Public methods
    public func configure(text: String, backgroundColorHex: String, textColorHex: String) {
        statusLabel.setTextWithCurrentAttributes(text: text.uppercased())
        container.backgroundColor = UIColor(backgroundColorHex)
        statusLabel.textColor = UIColor(textColorHex)
    }
    
    public func configure(text: String, backgroundColor: UIColor, textColor: UIColor) {
        statusLabel.setTextWithCurrentAttributes(text: text.uppercased())
        container.backgroundColor = backgroundColor
        statusLabel.textColor = textColor
    }
    
    public func configureUI(statusFont: UIFont) {
        statusLabel.font = statusFont
    }
}

private extension LabelStatusView {
    enum Constants {
        static let labelInsets: UIEdgeInsets = .init(top: 2, left: 12, bottom: 2, right: 12)
    }
}
