
import Foundation
import UIKit

/// design_system_code: textLabelContainerMlc

final public class DSChipStatusAtmView: BaseCodeView {
    
    private let statusLabel = UILabel().withParameters(font: FontBook.statusFont)
    private let roundView = VerticalRoundView()
    
    override public func setupSubviews() {
        backgroundColor = .clear
        roundView.addSubview(statusLabel)
        addSubview(roundView)
        statusLabel.anchor(top: roundView.topAnchor,
                           leading: roundView.leadingAnchor,
                           bottom: roundView.bottomAnchor,
                           trailing: roundView.trailingAnchor,
                           padding: Constants.padding,
                           size: Constants.size)
        roundView.anchor(top: topAnchor,
                         leading: leadingAnchor,
                         bottom: bottomAnchor,
                         trailing: nil)
    }
    
    public func configure(for model: DSCardStatusChipModel) {
        self.accessibilityIdentifier = model.componentId
        statusLabel.text = model.name
        statusLabel.textColor = UIColor(model.statusTextColor)
        roundView.backgroundColor = UIColor(model.statusViewColor)
        if model.type == .white {
            roundView.withBorder(width: Constants.borderWidth,
                                 color: .lightGray)
        }
    }
    
    static func widthForText(text: String) -> CGFloat {
        let textWidth = text.width(withConstrainedHeight: .greatestFiniteMagnitude, font: FontBook.statusFont)
        let labelHInsets = Constants.padding.left + Constants.padding.right
        let borderHInsets = Constants.borderWidth * 2
        return textWidth + labelHInsets  + borderHInsets
    }
}

extension DSChipStatusAtmView {
    enum Constants {
        static let borderWidth: CGFloat = 1
        static let superPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        static let padding = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
        static let size = CGSize(width: 0, height: 16)
    }
}
