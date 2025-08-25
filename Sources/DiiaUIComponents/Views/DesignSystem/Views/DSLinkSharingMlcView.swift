
import UIKit

/// design_system_code: linkSharingMlc
public class DSLinkSharingMlcView: BaseCodeView {
    private let titleLabel = UILabel().withParameters(font: FontBook.smallHeadingFont, numberOfLines: 1, textAlignment: .center, lineBreakMode: .byTruncatingTail)

    override public func setupSubviews() {
        addSubview(titleLabel)
        titleLabel.fillSuperview()
    }

    public func configure(with model: DSLinkSharingMlcModel) {
        accessibilityIdentifier = model.componentId
        titleLabel.text = model.label
    }
}
