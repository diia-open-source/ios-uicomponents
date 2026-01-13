
import UIKit
import DiiaCommonTypes

public final class DSTableMainHeadingViewModel {
    public let headingModel: DSTableHeadingItemModel
    public let onClickAction: Callback?

    public init(headingModel: DSTableHeadingItemModel, onClickAction: Callback? = nil) {
        self.headingModel = headingModel
        self.onClickAction = onClickAction
    }
}

/// design_system_code: tableMainHeadingMlc
public final class DSTableMainHeadingView: BaseCodeView {
    // MARK: - Subviews
    private let titleLabel = UILabel().withParameters(font: FontBook.smallHeadingFont)
    private let descriptionLabel = UILabel().withParameters(font: FontBook.usualFont, textColor: Constants.valueTextColor)

    private lazy var labelsStackView = UIStackView.create(views: [titleLabel, descriptionLabel], spacing: Constants.spacing)

    private let headingButton = ActionButton(type: .icon)

    // MARK: - Properties
    private var viewModel: DSTableMainHeadingViewModel?
    
    // MARK: - Init
    public override func setupSubviews() {
        headingButton.tintColor = .black
        headingButton.isHidden = true
        headingButton.withSize(Constants.buttonSize)

        UIStackView.create(
            .horizontal,
            views: [labelsStackView, headingButton],
            spacing: Constants.spacing,
            alignment: .top,
            in: self
        )
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: DSTableMainHeadingViewModel) {
        self.viewModel = viewModel

        titleLabel.text = viewModel.headingModel.label
        titleLabel.accessibilityLabel = viewModel.headingModel.label

        descriptionLabel.isHidden = viewModel.headingModel.description == nil
        if let description = viewModel.headingModel.description {
            descriptionLabel.text = description
            descriptionLabel.accessibilityLabel = description
        }

        headingButton.isHidden = viewModel.headingModel.icon?.action == nil
        if let iconModel = viewModel.headingModel.icon, let callback = viewModel.onClickAction {
            let imageProvider = UIComponentsConfiguration.shared.imageProvider
            headingButton.accessibilityLabel = iconModel.accessibilityDescription
            headingButton.action = Action(iconName: imageProvider.imageNameForCode(imageCode: iconModel.code),
                                          callback: callback)
        }
    }
}

// MARK: - Constants
private extension DSTableMainHeadingView {
    enum Constants {
        static let valueTextColor: UIColor = .black.withAlphaComponent(0.4)
        static let spacing: CGFloat = 8
        static let buttonSize = CGSize(width: 24, height: 24)
    }
}
