
import Foundation
import UIKit

public final class DSCurrentTimeMlcView: BaseCodeView {
    private let dateLabel = UILabel()
    
    public override func setupSubviews() {
        addSubview(dateLabel)
        dateLabel.anchor(top: topAnchor,
                         leading: leadingAnchor,
                         bottom: bottomAnchor,
                         trailing: trailingAnchor,
                         padding: .init(top: Constants.offset,
                                        left: .zero,
                                        bottom: Constants.offset,
                                        right: .zero))
        dateLabel.textAlignment = .center
        dateLabel.font = FontBook.smallHeadingFont
    }
    
    public func configure(for model: DSCurrentTimeMlc) {
        accessibilityIdentifier = model.componentId
        dateLabel.text = model.label
    }
}

extension DSCurrentTimeMlcView {
    enum Constants {
        static let offset: CGFloat = 12
    }
}
