
import UIKit

/// design_system_code: linkSharingMlc
public final class DSLinkSharingMlcView: BaseCodeView {
    private let titleLabel = UILabel().withParameters(font: FontBook.smallHeadingFont, numberOfLines: 1, textAlignment: .center, lineBreakMode: .byTruncatingTail)
    private let iconRight = DSIconView()
    private let mainHStack = UIStackView.create(.horizontal, spacing: Constants.spacing)

    //MARK: Lifecycle
    override public func setupSubviews() {
        addSubview(mainHStack)
        mainHStack.fillSuperview()
        iconRight.withSize(Constants.iconSize)
        mainHStack.addArrangedSubviews([
            UIView().withWidth(Constants.spacerWidth),
            titleLabel,
            iconRight
        ])
    }

    //MARK: Public methods
    public func configure(with model: DSLinkSharingMlcModel, eventHandler: ((ConstructorItemEvent) -> Void)? = nil) {
        accessibilityIdentifier = model.componentId
        titleLabel.text = model.label
        if let iconRight = model.iconRight {
            self.iconRight.setIcon(iconRight)
            self.iconRight.onClick = { action in
                guard let action = action else { return }
                eventHandler?(.action(action))
            }
        }
    }
}

private extension DSLinkSharingMlcView {
    enum Constants {
        static let iconSize = CGSize(width: 24, height: 24)
        static let spacerWidth: CGFloat = 32.0
        static let spacing: CGFloat = 8.0
    }
}
