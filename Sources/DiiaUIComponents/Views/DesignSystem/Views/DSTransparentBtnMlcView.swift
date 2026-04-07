
import UIKit
import DiiaCommonTypes

///ds_code: transparentBtnMlc
public final class DSTransparentBtnMlcView: BaseCodeView {
    private let label = UILabel().withParameters(font: Constants.labelFont, textAlignment: .left)
    private let iconView = DSIconView()

    private lazy var contentStack = UIStackView.create(
        .horizontal,
        views: [label, iconView],
        spacing: Constants.spacing
    )

    public override func setupSubviews() {
        backgroundColor = Constants.backgroundColor
        withBorder(width: 1, color: Constants.borderColor, cornerRadius: Constants.cornerRadius)
        iconView.withSize(Constants.imageSize)

        addSubview(contentStack)
        contentStack.fillSuperview(padding: .allSides(Constants.padding))
    }

    func configure(with model: DSTransparentBtnMlcModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        accessibilityIdentifier = model.componentId
        label.text = model.label
        iconView.setIcon(model.iconRight)

        if let action = model.action {
            self.tapGestureRecognizer {
                eventHandler(.action(action))
            }
        }

        switch model.state {
        case .disabled:
            isUserInteractionEnabled = false
            alpha = Constants.disabledAlpha
        default:
            isUserInteractionEnabled = true
            alpha = Constants.defaultAlpha
        }
    }
}

private extension DSTransparentBtnMlcView {
    enum Constants {
        static let backgroundColor: UIColor = .white.withAlphaComponent(0.3)
        static let borderColor: UIColor = .white
        static let spacing: CGFloat = 8
        static let cornerRadius: CGFloat = 16
        static let padding: CGFloat = 16
        static let imageSize: CGSize = .init(width: 24, height: 24)
        static let defaultAlpha: CGFloat = 1
        static let disabledAlpha: CGFloat = 0.54
        static let labelFont = FontBook.mainFont.regular.size(14)
    }
}
