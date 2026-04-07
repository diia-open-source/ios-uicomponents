
import UIKit

/// design_system_code: dotChipStatusMlc
final public class DSDotChipStatusMlcView: BaseCodeView {
    private let indicatorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.indicatorSize.height * 0.5
        view.clipsToBounds = true
        return view
    }()

    private let statusLabel = UILabel().withParameters(font: FontBook.usualFont)

    private lazy var contentHStack = UIStackView.create(
        .horizontal,
        views: [indicatorView, statusLabel],
        spacing: Constants.spacing,
        alignment: .center,
    )

    override public func setupSubviews() {
        clipsToBounds = true
        backgroundColor = Constants.backgroundColor

        addSubview(contentHStack)
        contentHStack.fillSuperview(padding: Constants.padding)

        indicatorView.anchor(size: Constants.indicatorSize)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height * 0.5
    }

    public func configure(for model: DSDotChipStatusMlcModel) {
        accessibilityIdentifier = model.componentId

        statusLabel.text = model.label
        indicatorView.backgroundColor = model.type.statusViewColor
        indicatorView.isHidden = !model.isVisible
    }
}

private extension DSDotChipStatusMlcView {
    enum Constants {
        static let padding = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
        static let indicatorSize = CGSize(width: 8, height: 8)
        static let spacing: CGFloat = 4
        static let backgroundColor = UIColor.white.withAlphaComponent(0.5)
    }
}

private extension DSCardStatusChipType {
    var statusViewColor: UIColor? {
        switch self {
        case .fail:
            return UIColor(AppConstants.Colors.persianRed)
        case .neutral:
            return UIColor(AppConstants.Colors.dadaGray)
        case .pending:
            return UIColor(AppConstants.Colors.statusYellow)
        case .success:
            return UIColor(AppConstants.Colors.statusGreen)
        case .white:
            return UIColor(AppConstants.Colors.white)
        case .blue:
            return UIColor(AppConstants.Colors.statusBlue)
        }
    }
}
